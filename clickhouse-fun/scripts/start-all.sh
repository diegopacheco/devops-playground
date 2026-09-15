#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "starting"

require podman-compose
podman-compose up -d
wait_port_up "$CLICKHOUSE_PORT" 60 || fail "clickhouse did not open port $CLICKHOUSE_PORT"
wait_clickhouse 60 || fail "clickhouse did not create the metrics table, see podman logs clickhouse-fun"
log "clickhouse up on $(service_url clickhouse)"

require go
( cd "$ROOT/backend" && go build -o "$RUN/backend" . ) || fail "backend build failed"
BACKEND_PORT="$(service_port backend)"
PORT="$BACKEND_PORT" CLICKHOUSE_URL="http://localhost:$CLICKHOUSE_PORT" CLICKHOUSE_DB="$CH_DB" \
  CLICKHOUSE_USER="$CH_USER" CLICKHOUSE_PASSWORD="$CH_PASSWORD" \
  start_bg backend "$ROOT/backend" "$RUN/backend"
wait_port_up "$BACKEND_PORT" 60 || fail "backend did not open port $BACKEND_PORT, see $LOGS/backend.log"
log "backend up on $(service_url backend)"

FRONTEND_PORT="$(service_port frontend)"
BACKEND_URL="http://localhost:$BACKEND_PORT" \
  start_bg frontend "$ROOT/frontend" npx next dev --port "$FRONTEND_PORT"
wait_port_up "$FRONTEND_PORT" 60 || fail "frontend did not open port $FRONTEND_PORT, see $LOGS/frontend.log"
log "frontend up on $(service_url frontend)"

"$SCRIPTS/status.sh"

log "links"
for name in $(service_names); do
  printf "%-14s %s\n" "$name" "$(service_url "$name")"
done
