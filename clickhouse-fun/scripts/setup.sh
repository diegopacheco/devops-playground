#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "setup started"

require podman
require podman-compose
podman-compose pull

require go
( cd "$ROOT/backend" && go mod download && go build -o "$RUN/backend" . ) || fail "backend build failed"

require npm
( cd "$ROOT/frontend" && npm install ) || fail "frontend npm install failed"

log "setup done"
