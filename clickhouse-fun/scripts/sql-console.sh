#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

port_up "$CLICKHOUSE_PORT" || fail "clickhouse is not running on $CLICKHOUSE_PORT, run ./scripts/start-all.sh first"

podman exec -it clickhouse-fun clickhouse-client --user "$CH_USER" --password "$CH_PASSWORD" --database "$CH_DB" "$@"
