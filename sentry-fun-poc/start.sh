#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

[ -d "$SELF_HOSTED_DIR" ] || fail "self-hosted is missing, run ./build.sh first"

ensure_machine

log "starting the sentry stack"
dc up --force-recreate -d

wait_sentry_ready
ensure_user
complete_setup

export SENTRY_NETWORK="$(sentry_network)"
export SENTRY_DSN="$(resolve_dsn)"

log "sentry ui       $SENTRY_URL"
log "sentry login    $SENTRY_EMAIL / $SENTRY_PASSWORD"
log "app network     $SENTRY_NETWORK"
log "app dsn         http://***@nginx/${SENTRY_DSN##*/}"

log "running the python app"
podman-compose -f "$ROOT/podman-compose.yml" up --abort-on-container-exit app
podman-compose -f "$ROOT/podman-compose.yml" down >/dev/null 2>&1 || true

log "done, open $SENTRY_URL to see errors, logs and metrics"
