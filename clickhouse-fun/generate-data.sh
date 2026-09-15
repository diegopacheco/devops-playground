#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/common.sh"

HOURS="${1:-24}"
STEP="${2:-10}"

case "$HOURS$STEP" in
  *[!0-9]*) fail "usage: ./generate-data.sh [hours] [step-seconds], both positive integers" ;;
esac
[ "$HOURS" -gt 0 ] && [ "$STEP" -gt 0 ] || fail "hours and step-seconds must be greater than zero"

port_up "$CLICKHOUSE_PORT" || fail "clickhouse is not running on $CLICKHOUSE_PORT, run ./scripts/start-all.sh first"
wait_clickhouse 30 || fail "clickhouse did not become ready"

NOW="$(date +%s)"
START=$((NOW - HOURS * 3600))

generate() {
  awk -v start="$START" -v end="$NOW" -v step="$STEP" -v seed="$NOW" '
    function clamp(v, lo, hi) { return v < lo ? lo : (v > hi ? hi : v) }
    function row(t, s, h, m, v) { printf "%d,%s,%s,%s,%.3f\n", t, s, h, m, v }
    BEGIN {
      srand(seed)
      pi = 3.14159265
      split("checkout payments catalog search auth", services, " ")
      split("35 50 25 45 20", cpu, " ")
      split("120 180 40 90 25", latency, " ")
      split("150 90 400 320 600", rps, " ")
      split("768 1024 512 2048 256", mem, " ")
      for (t = start; t <= end; t += step) {
        wave = sin(2 * pi * (t % 86400) / 86400)
        ripple = sin(2 * pi * (t % 900) / 900)
        for (i = 1; i <= 5; i++) {
          s = services[i]
          for (k = 1; k <= 2; k++) {
            h = s "-" k
            spike = rand() < 0.004 ? 1 : 0
            load = 1 + 0.35 * wave + 0.1 * ripple
            r = rps[i] * load * (0.9 + rand() * 0.2)
            row(t, s, h, "cpu_percent", clamp(cpu[i] * load + rand() * 8 + spike * 40, 0, 100))
            row(t, s, h, "memory_mb", mem[i] * (1 + 0.05 * wave) + rand() * 40 + k * 16)
            row(t, s, h, "latency_ms", latency[i] * load * (0.85 + rand() * 0.3) * (spike ? 4 : 1))
            row(t, s, h, "requests_per_sec", r)
            row(t, s, h, "errors_per_sec", r * (0.002 + rand() * 0.004) * (spike ? 15 : 1))
          }
        }
      }
    }'
}

log "generating $HOURS hours of metrics every $STEP seconds for 5 services, 2 hosts each"

HEADERS="$RUN/generate-data.headers"
generate | curl -sS --fail-with-body -D "$HEADERS" -o /dev/null \
  -H "X-ClickHouse-User: $CH_USER" -H "X-ClickHouse-Key: $CH_PASSWORD" \
  "http://localhost:$CLICKHOUSE_PORT/?database=$CH_DB&query=INSERT%20INTO%20metrics%20SELECT%20toDateTime64(t%2C%203)%2C%20service%2C%20host%2C%20metric%2C%20value%20FROM%20input('t%20UInt32%2C%20service%20String%2C%20host%20String%2C%20metric%20String%2C%20value%20Float64')%20FORMAT%20CSV" \
  --data-binary @- || fail "insert into clickhouse failed"

summary_field() {
  grep -i '^X-ClickHouse-Summary:' "$HEADERS" | sed -E "s/.*\"$1\":\"([0-9]+)\".*/\1/"
}

written_rows="$(summary_field written_rows)"
written_bytes="$(summary_field written_bytes)"
elapsed_ns="$(summary_field elapsed_ns)"
elapsed_ms=$((elapsed_ns / 1000000))
[ "$elapsed_ms" -gt 0 ] || elapsed_ms=1
rows_per_sec=$((written_rows * 1000 / elapsed_ms))

log ""
log "insert metrics"
printf "  %-22s %s\n" "rows written" "$written_rows"
printf "  %-22s %s\n" "bytes written" "$written_bytes"
printf "  %-22s %s ms\n" "insert elapsed" "$elapsed_ms"
printf "  %-22s %s\n" "rows per second" "$rows_per_sec"

log ""
log "table metrics"
ch_query "SELECT
    formatReadableQuantity((SELECT count() FROM metrics)),
    formatReadableSize(sum(data_uncompressed_bytes)),
    formatReadableSize(sum(data_compressed_bytes)),
    round(sum(data_uncompressed_bytes) / greatest(sum(data_compressed_bytes), 1), 2),
    count()
FROM system.parts WHERE active AND database = currentDatabase() AND table = 'metrics'
FORMAT TSV" | awk -F'\t' '{
  printf "  %-22s %s\n", "total rows", $1
  printf "  %-22s %s\n", "uncompressed size", $2
  printf "  %-22s %s\n", "compressed size", $3
  printf "  %-22s %sx\n", "compression ratio", $4
  printf "  %-22s %s\n", "active parts", $5
}'

log ""
log "rows per metric"
ch_query "SELECT metric, count(), round(avg(value), 2), round(quantile(0.95)(value), 2) FROM metrics GROUP BY metric ORDER BY metric FORMAT TSV" |
  awk -F'\t' 'BEGIN { printf "  %-18s %-10s %-10s %s\n", "metric", "rows", "avg", "p95" } { printf "  %-18s %-10s %-10s %s\n", $1, $2, $3, $4 }'
