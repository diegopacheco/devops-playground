#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

log "stopping the python app"
SENTRY_DSN="" SENTRY_NETWORK="$(sentry_network)" \
  podman-compose -f "$ROOT/podman-compose.yml" down >/dev/null 2>&1 || true

if [ -d "$SELF_HOSTED_DIR" ]; then
  log "stopping the sentry stack"
  dc down
fi

log "stopped"
