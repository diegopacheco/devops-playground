#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

log "tests started"

BACKEND_PORT="$(service_port backend)"
port_up "$POSTGRES_PORT" || fail "tests need postgres with the tin extension, run ./scripts/start-all.sh first"
port_up "$BACKEND_PORT" || fail "tests need the backend, run ./scripts/start-all.sh first"

require go
( cd "$ROOT/backend" && DATABASE_URL="$(service_url postgres)" go test -count=1 -v ./... ) || fail "backend tests failed"
log "backend unit and tin integration tests passed"

api="$(service_url backend)/api"

body="$(curl -sS --fail "$api/search?q=jalapeno")"
printf "%s" "$body" | grep -q '"title":"Jalapeño poppers"' || fail "api search did not fold accents: $body"
log "api search returns ranked results"

code="$(curl -s -o /dev/null -w '%{http_code}' "$api/search?q=%22unclosed")"
[ "$code" = "400" ] || fail "malformed TINQL should be rejected with 400, got $code"
log "api rejects malformed TINQL with 400"

body="$(curl -sS --fail "$api/tokenize?text=Jalape%C3%B1o")"
printf "%s" "$body" | grep -q 'jalapeno' || fail "tokenizer did not fold jalapeño: $body"
log "api tokenizer folds accents"

log "tests passed"
