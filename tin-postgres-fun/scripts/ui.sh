#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

port="$(service_port backend)"
[ -n "$port" ] || fail "backend is not declared in scripts/ports.env"

url="$(service_url backend)"
port_up "$port" || fail "backend is not running on $port, run ./scripts/start-all.sh first"

log "opening $url"
open_url "$url"
