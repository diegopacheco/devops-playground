#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "starting"

require podman
podman image exists localhost/tin-postgres-lead:18 || fail "postgres image missing, run ./scripts/setup.sh first"

require podman-compose
podman-compose up -d
wait_port_up "$POSTGRES_PORT" 60 || fail "postgres did not open port $POSTGRES_PORT"
wait_postgres 60 || fail "postgres did not create the tin index, see podman logs $PG_CONTAINER"
log "postgres up on $(service_url postgres)"

require go
( cd "$ROOT/backend" && go build -o "$RUN/backend" . ) || fail "backend build failed"
BACKEND_PORT="$(service_port backend)"
PORT="$BACKEND_PORT" DATABASE_URL="$(service_url postgres)" \
  start_bg backend "$ROOT/backend" "$RUN/backend"
wait_port_up "$BACKEND_PORT" 60 || fail "backend did not open port $BACKEND_PORT, see $LOGS/backend.log"
log "backend up on $(service_url backend)"

"$SCRIPTS/status.sh"

log "links"
for name in $(service_names); do
  printf "%-10s %s\n" "$name" "$(service_url "$name")"
done
printf "%-10s %s\n" "api" "$(service_url backend)/api/search?q=java"
