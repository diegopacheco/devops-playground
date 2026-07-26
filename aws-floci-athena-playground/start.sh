#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"
podman info >/dev/null 2>&1 || podman machine start
if machine_uid="$(podman machine ssh 'id -u' 2>/dev/null)"; then
  export PODMAN_SOCKET_PATH="/run/user/${machine_uid}/podman/podman.sock"
else
  export PODMAN_SOCKET_PATH="${XDG_RUNTIME_DIR}/podman/podman.sock"
fi
export APP_PORT="${APP_PORT:-8081}"
export FLOCI_PORT="${FLOCI_PORT:-4567}"
export AI_BRIDGE_PORT="${AI_BRIDGE_PORT:-3031}"
mkdir -p data
bridge_pid_file="$script_dir/data/ai-bridge.pid"
bridge_label="io.flocus.ai-bridge"
if [[ "$(uname -s)" == "Darwin" ]]; then
  launchctl remove "$bridge_label" >/dev/null 2>&1 || :
  rm -f "$bridge_pid_file"
else
  if [[ -f "$bridge_pid_file" ]]; then
    bridge_pid="$(<"$bridge_pid_file")"
    if kill -0 "$bridge_pid" 2>/dev/null && [[ "$(ps -p "$bridge_pid" -o command=)" == *"src/ai-bridge.js"* ]]; then
      kill "$bridge_pid"
      for attempt in {1..5}; do
        kill -0 "$bridge_pid" 2>/dev/null || break
        sleep 1
      done
    fi
    rm -f "$bridge_pid_file"
  fi
fi
export AI_BRIDGE_TOKEN="$(node -e 'process.stdout.write(require("node:crypto").randomUUID())')"
if [[ "$(uname -s)" == "Darwin" ]]; then
  node_path="$(command -v node)"
  launchctl submit -l "$bridge_label" -o "$script_dir/data/ai-bridge.log" -e "$script_dir/data/ai-bridge.log" -- /usr/bin/env "PATH=$PATH" "AI_BRIDGE_PORT=$AI_BRIDGE_PORT" "AI_BRIDGE_TOKEN=$AI_BRIDGE_TOKEN" "$node_path" "$script_dir/src/ai-bridge.js"
else
  AI_BRIDGE_PORT="$AI_BRIDGE_PORT" AI_BRIDGE_TOKEN="$AI_BRIDGE_TOKEN" nohup node "$script_dir/src/ai-bridge.js" > "$script_dir/data/ai-bridge.log" 2>&1 &
  bridge_pid="$!"
  printf '%s\n' "$bridge_pid" > "$bridge_pid_file"
fi
bridge_ready=false
for attempt in {1..10}; do
  if curl --max-time 1 -fsS -H "Authorization: Bearer ${AI_BRIDGE_TOKEN}" "http://localhost:${AI_BRIDGE_PORT}/health" >/dev/null 2>&1; then
    bridge_ready=true
    break
  fi
  sleep 1
done
if [[ "$bridge_ready" != true ]]; then
  sed -n '1,120p' "$script_dir/data/ai-bridge.log"
  exit 1
fi
podman-compose -f podman-compose.yml up -d floci
app_container="$(basename "$script_dir")_app_1"
if podman container exists "$app_container"; then
  podman rm -f "$app_container"
fi
podman-compose -f podman-compose.yml up -d --build --no-deps app
for attempt in {1..60}; do
  if curl --max-time 1 -fsS "http://localhost:${APP_PORT}/api/status" >/dev/null 2>&1; then
    printf '%s\n' "Athena Playground is ready at http://localhost:${APP_PORT}"
    exit 0
  fi
  sleep 1
done
printf '%s\n' "Athena Playground did not become ready within 60 seconds"
podman-compose -f podman-compose.yml logs app
podman-compose -f podman-compose.yml logs floci
exit 1
