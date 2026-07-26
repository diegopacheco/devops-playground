#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
podman-compose down
if [ -s data/ai-bridge.pid ]; then
  bridge_pid="$(tr -d '[:space:]' < data/ai-bridge.pid)"
  if [[ "$bridge_pid" =~ ^[0-9]+$ ]] && kill -0 "$bridge_pid" 2>/dev/null; then
    kill "$bridge_pid"
  fi
  rm -f data/ai-bridge.pid
fi
echo "IAM Forge stopped"
