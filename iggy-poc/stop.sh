#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

if [ "${1:-}" = "--purge" ]; then
  log "stopping the stack and deleting the iggy data volume"
  dc down --volumes
else
  log "stopping the stack, the iggy data volume is kept"
  dc down
fi

log "stopped"
