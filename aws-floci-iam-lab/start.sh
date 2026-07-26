#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p data
if [ ! -s data/ai-token ]; then
  openssl rand -hex 24 > data/ai-token
  chmod 600 data/ai-token
fi
bridge_running=0
if [ -s data/ai-bridge.pid ]; then
  bridge_pid="$(tr -d '[:space:]' < data/ai-bridge.pid)"
  if [[ "$bridge_pid" =~ ^[0-9]+$ ]] && kill -0 "$bridge_pid" 2>/dev/null; then
    bridge_running=1
  fi
fi
if [ "$bridge_running" -eq 0 ]; then
  nohup node ai-bridge.js > data/ai-bridge.log 2>&1 &
  bridge_pid=$!
  printf '%s\n' "$bridge_pid" > data/ai-bridge.pid
fi
bridge_ready=0
bridge_token="$(tr -d '[:space:]' < data/ai-token)"
for _ in {1..60}; do
  if curl -fsS -H "x-iam-forge-token: $bridge_token" http://127.0.0.1:18787/status >/dev/null 2>&1; then
    bridge_ready=1
    break
  fi
  sleep 1
done
if [ "$bridge_ready" -ne 1 ]; then
  echo "AI bridge did not become ready"
  exit 1
fi
podman-compose up -d --build
playground_ready=0
for _ in {1..60}; do
  if curl -fsS http://127.0.0.1:8080/api/health >/dev/null 2>&1; then
    playground_ready=1
    break
  fi
  sleep 1
done
if [ "$playground_ready" -ne 1 ]; then
  echo "IAM Forge did not become ready"
  exit 1
fi
echo "IAM Forge is ready at http://127.0.0.1:8080"
