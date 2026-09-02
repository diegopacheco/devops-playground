#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$ROOT/podman-compose.yml"

IGGY_API="${IGGY_API:-http://localhost:3000}"
IGGY_UI="${IGGY_UI:-http://localhost:3050}"
IGGY_TCP="${IGGY_TCP:-localhost:8090}"
IGGY_USERNAME="${IGGY_USERNAME:-iggy}"
IGGY_PASSWORD="${IGGY_PASSWORD:-iggy}"

STREAM=orders
TOPIC=placed
CONSUMER_GROUP=billing

export IGGY_MESSAGE_COUNT="${IGGY_MESSAGE_COUNT:-20}"

log() { echo "[iggy-poc] $*"; }

fail() {
  echo "[iggy-poc] FAIL: $*" >&2
  exit 1
}

dc() { podman-compose -f "$COMPOSE_FILE" "$@"; }

wait_http() {
  local url="$1" name="$2" waited=0
  while [ "$(curl -s -o /dev/null -w '%{http_code}' "$url" 2>/dev/null)" != "200" ]; do
    waited=$((waited + 1))
    [ "$waited" -gt 60 ] && fail "$name did not answer on $url"
    sleep 1
  done
  log "$name is up"
}

wait_iggy() { wait_http "$IGGY_API/ping" "iggy server"; }

wait_ui() { wait_http "$IGGY_UI/healthz" "iggy web ui"; }

wait_container_exit() {
  local name="$1" waited=0
  while [ "$(podman inspect -f '{{.State.Running}}' "$name" 2>/dev/null)" != "false" ]; do
    waited=$((waited + 1))
    [ "$waited" -gt 60 ] && fail "$name did not finish"
    sleep 1
  done
}

api_token() {
  curl -s -m 10 -X POST "$IGGY_API/users/login" \
    -H 'content-type: application/json' \
    -d "{\"username\":\"$IGGY_USERNAME\",\"password\":\"$IGGY_PASSWORD\"}" |
    python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"]["token"])'
}

api_get() {
  curl -s -m 10 -H "authorization: Bearer $2" "$IGGY_API$1"
}

topic_messages() {
  api_get "/streams/$STREAM/topics/$TOPIC" "$1" |
    python3 -c 'import json,sys
try:
    print(json.load(sys.stdin)["messages_count"])
except Exception:
    print(0)'
}

consumer_group_members() {
  api_get "/streams/$STREAM/topics/$TOPIC/consumer-groups" "$1" |
    python3 -c 'import json,sys
try:
    print(len(json.load(sys.stdin)))
except Exception:
    print(0)'
}

print_access() {
  echo ""
  echo "  ---------------------------------------------------------------"
  echo "  web ui       $IGGY_UI/auth/sign-in"
  echo "  http api     $IGGY_API"
  echo "  tcp          $IGGY_TCP"
  echo "  user         $IGGY_USERNAME"
  echo "  password     $IGGY_PASSWORD"
  echo "  ---------------------------------------------------------------"
  echo ""
}
