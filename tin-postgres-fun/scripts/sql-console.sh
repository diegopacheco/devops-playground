#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

port_up "$POSTGRES_PORT" || fail "postgres is not running on $POSTGRES_PORT, run ./scripts/start-all.sh first"

podman exec -it "$PG_CONTAINER" psql -U "$PG_USER" -d "$PG_DB" "$@"
