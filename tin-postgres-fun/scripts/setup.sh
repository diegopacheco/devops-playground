#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "setup started"

require podman
require podman-compose
if podman image exists localhost/tin-postgres-lead:18; then
  log "image localhost/tin-postgres-lead:18 already built"
else
  log "building postgres 18 with the Lead tin extension, the first build compiles Rust and takes several minutes"
  podman-compose build || fail "postgres image build failed"
fi

require go
( cd "$ROOT/backend" && go mod download && go build -o "$RUN/backend" . ) || fail "backend build failed"

log "setup done"
