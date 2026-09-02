#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

log "recreating the stack for a clean run"
dc down >/dev/null 2>&1 || true
dc up -d iggy ui >/dev/null
wait_iggy
wait_ui

TOKEN="$(api_token)"
[ -n "$TOKEN" ] || fail "could not log in to the iggy http api"
BEFORE="$(topic_messages "$TOKEN")"
log "topic $STREAM/$TOPIC holds $BEFORE messages before the run"

dc up -d consumer >/dev/null
dc up -d producer >/dev/null
wait_container_exit iggy-producer
wait_container_exit iggy-consumer

SENT="$(podman logs iggy-producer 2>/dev/null | grep -c '^sent ' || true)"
RECEIVED="$(podman logs iggy-consumer 2>/dev/null | grep -c '^received ' || true)"
PARTITIONS="$(podman logs iggy-consumer 2>/dev/null | grep '^received ' | sed 's/.*partition=\([0-9]*\).*/\1/' | sort -u | wc -l | tr -d ' ')"
AFTER="$(topic_messages "$TOKEN")"
GROUP_COUNT="$(consumer_group_members "$TOKEN")"
STORED=$((AFTER - BEFORE))

status=0
report() {
  local name="$1" expected="$2" actual="$3"
  if [ "$actual" = "$expected" ]; then
    printf '  PASS  %-24s expected %s got %s\n' "$name" "$expected" "$actual"
  else
    printf '  FAIL  %-24s expected %s got %s\n' "$name" "$expected" "$actual"
    status=1
  fi
}

echo ""
echo "iggy-poc results"
report "messages sent" "$IGGY_MESSAGE_COUNT" "$SENT"
report "messages received" "$IGGY_MESSAGE_COUNT" "$RECEIVED"
report "messages stored" "$IGGY_MESSAGE_COUNT" "$STORED"
report "partitions used" 3 "$PARTITIONS"
report "consumer groups" 1 "$GROUP_COUNT"
echo ""

[ "$status" -eq 0 ] || fail "the stream did not carry every message end to end"
log "every message went from the rust producer through iggy to the rust consumer"
print_access
