#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

EAP_LOG_TYPE="${EAP_LOG_TYPE:-3}"
EAP_METRIC_TYPE="${EAP_METRIC_TYPE:-8}"
POLL_LIMIT="${POLL_LIMIT:-180}"

[ -d "$SELF_HOSTED_DIR" ] || fail "self-hosted is missing, run ./build.sh first"
wait_sentry_ready

eap_table() {
  clickhouse_query "show tables from default" | grep -E '^eap_items_[0-9]+_local$' | head -1
}

EAP_TABLE="$(eap_table)"
[ -n "$EAP_TABLE" ] || fail "no eap items table found in clickhouse"

count_errors() { clickhouse_query "select count() from default.errors_local"; }
count_transactions() { clickhouse_query "select count() from default.transactions_local"; }
count_eap() { clickhouse_query "select count() from default.$EAP_TABLE where item_type = $1"; }

read_counts() {
  ERRORS="$(count_errors)"
  TRANSACTIONS="$(count_transactions)"
  LOGS="$(count_eap "$EAP_LOG_TYPE")"
  METRICS="$(count_eap "$EAP_METRIC_TYPE")"
}

read_counts
BASE_ERRORS="$ERRORS"
BASE_TRANSACTIONS="$TRANSACTIONS"
BASE_LOGS="$LOGS"
BASE_METRICS="$METRICS"
log "baseline errors=$BASE_ERRORS transactions=$BASE_TRANSACTIONS logs=$BASE_LOGS metrics=$BASE_METRICS"

ensure_user
complete_setup
export SENTRY_NETWORK="$(sentry_network)"
export SENTRY_DSN="$(resolve_dsn)"
export RUNS="${RUNS:-5}"

log "running the python app with RUNS=$RUNS"
podman-compose -f "$ROOT/podman-compose.yml" up --abort-on-container-exit app
podman-compose -f "$ROOT/podman-compose.yml" down >/dev/null 2>&1 || true

log "waiting for sentry to ingest the payloads"
waited=0
while true; do
  read_counts
  if [ "$ERRORS" -gt "$BASE_ERRORS" ] &&
    [ "$TRANSACTIONS" -gt "$BASE_TRANSACTIONS" ] &&
    [ "$LOGS" -gt "$BASE_LOGS" ] &&
    [ "$METRICS" -gt "$BASE_METRICS" ]; then
    break
  fi
  waited=$((waited + 1))
  [ "$waited" -ge "$POLL_LIMIT" ] && break
  sleep 1
done

status=0
report() {
  local name="$1" before="$2" after="$3"
  if [ "$after" -gt "$before" ]; then
    printf '  PASS  %-14s %s -> %s\n' "$name" "$before" "$after"
  else
    printf '  FAIL  %-14s %s -> %s\n' "$name" "$before" "$after"
    status=1
  fi
}

echo ""
echo "sentry-fun-poc results after ${waited}s"
report errors "$BASE_ERRORS" "$ERRORS"
report transactions "$BASE_TRANSACTIONS" "$TRANSACTIONS"
report logs "$BASE_LOGS" "$LOGS"
report metrics "$BASE_METRICS" "$METRICS"
echo ""

[ "$status" -eq 0 ] || fail "not every signal reached sentry"
log "all signals reached sentry, browse them at $SENTRY_URL"
