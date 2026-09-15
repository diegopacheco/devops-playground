#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "tests started"

require go
( cd "$ROOT/backend" && go test ./... ) || fail "backend unit tests failed"
log "backend unit tests passed"

require npm
( cd "$ROOT/frontend" && npm test ) || fail "frontend unit tests failed"
log "frontend unit tests passed"

BACKEND_PORT="$(service_port backend)"
FRONTEND_PORT="$(service_port frontend)"
port_up "$BACKEND_PORT" || fail "integration tests need the app, run ./scripts/start-all.sh first"
port_up "$FRONTEND_PORT" || fail "integration tests need the app, run ./scripts/start-all.sh first"

total_rows() {
  curl -sS --fail "http://localhost:$1/api/stats" | sed -E 's/.*"rows":([0-9]+).*/\1/'
}

before="$(total_rows "$BACKEND_PORT")"
"$ROOT/generate-data.sh" 1 60 >/dev/null || fail "generate-data.sh failed"
after="$(total_rows "$BACKEND_PORT")"
expected=$((61 * 5 * 2 * 5))
[ $((after - before)) -eq "$expected" ] || fail "expected $expected new rows through the backend, got $((after - before))"
log "generated rows are visible through the backend api: +$expected"

summary="$(curl -sS --fail "http://localhost:$BACKEND_PORT/api/summary?minutes=60")"
for metric in cpu_percent memory_mb latency_ms requests_per_sec errors_per_sec; do
  printf "%s" "$summary" | grep -q "\"metric\":\"$metric\"" || fail "summary is missing $metric"
done
log "summary returns every generated metric"

code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$BACKEND_PORT/api/timeseries?metric=latency_ms&minutes=0")"
[ "$code" = "400" ] || fail "invalid window should be rejected with 400, got $code"
log "backend rejects invalid windows"

top="$(curl -sS --fail "http://localhost:$FRONTEND_PORT/api/top?metric=latency_ms&minutes=60&limit=5")"
printf "%s" "$top" | grep -q '"service":"payments"' || fail "frontend proxy did not return the top services"
log "frontend proxies the api to the backend"

log "tests passed"
