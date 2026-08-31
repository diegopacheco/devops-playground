#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

ensure_brew_bash
ensure_machine

if [ ! -d "$SELF_HOSTED_DIR/.git" ]; then
  log "cloning getsentry/self-hosted ($SELF_HOSTED_REF)"
  git clone --depth 1 --branch "$SELF_HOSTED_REF" "$SELF_HOSTED_REPO" "$SELF_HOSTED_DIR"
else
  log "self-hosted already cloned"
fi

patch_self_hosted

log "running sentry install.sh with podman"
(
  cd "$SELF_HOSTED_DIR"
  COMPOSE_PROFILES=feature-complete "$BASH_MODERN" ./install.sh \
    --container-engine-podman \
    --skip-user-creation \
    --skip-commit-check \
    --no-report-self-hosted-issues \
    --apply-automatic-config-updates
)

log "building the python app image"
podman-compose -f "$ROOT/podman-compose.yml" build app

log "build done"
