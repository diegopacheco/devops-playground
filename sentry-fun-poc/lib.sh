#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF_HOSTED_DIR="$ROOT/self-hosted"
SELF_HOSTED_REPO="${SELF_HOSTED_REPO:-https://github.com/getsentry/self-hosted.git}"
SELF_HOSTED_REF="${SELF_HOSTED_REF:-master}"

SENTRY_PORT="${SENTRY_PORT:-9000}"
SENTRY_URL="http://localhost:${SENTRY_PORT}"
SENTRY_EMAIL="${SENTRY_EMAIL:-admin@sentry.local}"
SENTRY_PASSWORD="${SENTRY_PASSWORD:-sentry-fun-poc}"

MACHINE_NAME="${MACHINE_NAME:-podman-machine-default}"
MACHINE_MEMORY=16384
MACHINE_CPUS=6

export COMPOSE_PROFILES=feature-complete

log() { echo "[sentry-poc] $*"; }
fail() {
  echo "[sentry-poc] FAIL: $*" >&2
  exit 1
}

brew_bash() {
  local candidate="/opt/homebrew/bin/bash"
  [ -x "$candidate" ] && echo "$candidate" && return 0
  candidate="/usr/local/bin/bash"
  [ -x "$candidate" ] && echo "$candidate" && return 0
  echo ""
}

ensure_brew_bash() {
  local found
  found="$(brew_bash)"
  if [ -z "$found" ]; then
    command -v brew >/dev/null 2>&1 || fail "homebrew is required to install bash 4.4+"
    log "installing bash via homebrew"
    brew install bash
    found="$(brew_bash)"
  fi
  [ -n "$found" ] || fail "bash 4.4+ not found after install"
  BASH_MODERN="$found"
  log "using $BASH_MODERN ($("$BASH_MODERN" -c 'echo $BASH_VERSION'))"
}

machine_field() {
  podman machine inspect "$MACHINE_NAME" 2>/dev/null |
    python3 -c "import json,sys; print(json.load(sys.stdin)[0]['Resources']['$1'])"
}

wait_machine_running() {
  local waited=0
  while [ "$(podman machine inspect "$MACHINE_NAME" 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin)[0]["State"])' 2>/dev/null)" != "running" ]; do
    waited=$((waited + 1))
    [ "$waited" -gt 120 ] && fail "podman machine did not reach running state"
    sleep 1
  done
}

ensure_machine() {
  podman machine inspect "$MACHINE_NAME" >/dev/null 2>&1 || fail "podman machine $MACHINE_NAME not found"
  local memory cpus
  memory="$(machine_field Memory)"
  cpus="$(machine_field CPUs)"
  if [ "$memory" -lt "$MACHINE_MEMORY" ] || [ "$cpus" -lt "$MACHINE_CPUS" ]; then
    log "resizing podman machine from ${memory}MB/${cpus}cpu to ${MACHINE_MEMORY}MB/${MACHINE_CPUS}cpu"
    podman machine stop "$MACHINE_NAME" >/dev/null 2>&1 || true
    podman machine set --memory "$MACHINE_MEMORY" --cpus "$MACHINE_CPUS" "$MACHINE_NAME"
    podman machine start "$MACHINE_NAME"
  fi
  wait_machine_running
  log "podman machine ready with $(machine_field Memory)MB and $(machine_field CPUs) cpus"
}

dc() { (cd "$SELF_HOSTED_DIR" && podman-compose --no-ansi --profile=feature-complete --in-pod=false "$@"); }

dcr() { (cd "$SELF_HOSTED_DIR" && podman-compose --no-ansi --profile=feature-complete --in-pod=false run --rm -T "$@"); }

psql_query() {
  dc exec -T postgres psql -qtAX -U postgres -d postgres -c "$1" 2>/dev/null | tr -d '\r' | grep -v '^$' | head -1
}

clickhouse_query() {
  dc exec -T clickhouse clickhouse-client -q "$1" 2>/dev/null | tr -d '\r'
}

sentry_network() {
  local net
  net="$(podman ps --format '{{.Names}} {{.Networks}}' | awk '$1 ~ /nginx/ {print $2; exit}')"
  net="${net%%,*}"
  if [ -z "$net" ]; then
    net="$(podman network ls --format '{{.Name}}' | grep -iE 'self.?hosted.*default' | head -1)"
  fi
  [ -n "$net" ] || fail "could not find the sentry compose network, is the stack running?"
  echo "$net"
}

wait_sentry_ready() {
  local waited=0
  while [ "$(curl -s -o /dev/null -w '%{http_code}' "$SENTRY_URL/_health/" 2>/dev/null)" != "200" ]; do
    waited=$((waited + 1))
    [ "$waited" -gt 600 ] && fail "sentry did not become healthy on $SENTRY_URL"
    sleep 1
  done
  log "sentry is healthy on $SENTRY_URL"
}

ensure_user() {
  local existing
  existing="$(psql_query "select count(*) from auth_user where email = '$SENTRY_EMAIL'")"
  if [ "${existing:-0}" = "0" ]; then
    log "creating superuser $SENTRY_EMAIL"
    dcr web createuser --email "$SENTRY_EMAIL" --password "$SENTRY_PASSWORD" --superuser --no-input
  else
    log "superuser $SENTRY_EMAIL already exists"
  fi
}

complete_setup() {
  local configured
  configured="$(psql_query "select count(*) from sentry_option where key = 'sentry:version-configured'")"
  if [ "${configured:-0}" != "0" ]; then
    log "sentry setup already completed"
    return 0
  fi
  log "completing the sentry setup wizard"
  dcr web django shell -c "
import sentry
from sentry import options
options.set('system.url-prefix', '$SENTRY_URL')
options.set('system.admin-email', '$SENTRY_EMAIL')
options.set('beacon.anonymous', True)
for key in options.filter(flag=options.FLAG_REQUIRED):
    if key.flags & options.FLAG_ALLOW_EMPTY or options.isset(key.name):
        continue
    try:
        options.set(key.name, options.get(key.name))
    except Exception as error:
        print('skipped %s: %s' % (key.name, error))
options.set('sentry:version-configured', sentry.get_version())
"
}

resolve_dsn() {
  local row key project
  row="$(psql_query "select k.public_key || ' ' || k.project_id from sentry_projectkey k order by k.id limit 1")"
  key="$(echo "$row" | awk '{print $1}')"
  project="$(echo "$row" | awk '{print $2}')"
  [ -n "$key" ] && [ -n "$project" ] || fail "could not resolve a sentry project key from postgres"
  echo "http://${key}@nginx/${project}"
}

patch_self_hosted() {
  log "patching self-hosted for podman on apple silicon"
  git -C "$SELF_HOSTED_DIR" checkout -- install/detect-platform.sh install/dc-detect-version.sh
  python3 - "$SELF_HOSTED_DIR" <<'EOF'
import sys, pathlib

root = pathlib.Path(sys.argv[1])

arch = root / "install" / "detect-platform.sh"
text = arch.read_text()
old = 'elif [[ "$DOCKER_ARCH" = "aarch64" ]]; then'
new = 'elif [[ "$DOCKER_ARCH" = "aarch64" || "$DOCKER_ARCH" = "arm64" ]]; then'
if old not in text:
    raise SystemExit("detect-platform.sh no longer matches the expected arch check")
arch.write_text(text.replace(old, new))
print("  detect-platform.sh accepts the arm64 arch podman reports")

dcv = root / "install" / "dc-detect-version.sh"
text = dcv.read_text()
anchor = 'if [[ "$CONTAINER_ENGINE" == "podman" ]]; then\n  NO_ANSI="--no-ansi"'
force = (
    'if [[ "$CONTAINER_ENGINE" == "podman" && -n "$dc_base_standalone" ]]; then\n'
    '  dc_base="$dc_base_standalone --profile=${COMPOSE_PROFILES:-feature-complete} --in-pod=false"\n'
    '  COMPOSE_VERSION="$STANDALONE_COMPOSE_VERSION"\n'
    'fi\n\n'
)
if anchor not in text:
    raise SystemExit("dc-detect-version.sh no longer matches the expected compose selection")
dcv.write_text(text.replace(anchor, force + anchor, 1))
print("  dc-detect-version.sh uses standalone podman-compose and passes --profile")
EOF
}
