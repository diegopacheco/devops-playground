#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"
if machine_uid="$(podman machine ssh 'id -u' 2>/dev/null)"; then
  export PODMAN_SOCKET_PATH="/run/user/${machine_uid}/podman/podman.sock"
else
  export PODMAN_SOCKET_PATH="${XDG_RUNTIME_DIR}/podman/podman.sock"
fi
network_name="$(basename "$script_dir")_default"
bridge_pid_file="$script_dir/data/ai-bridge.pid"
bridge_label="io.flocus.ai-bridge"
if [[ "$(uname -s)" == "Darwin" ]]; then
  launchctl remove "$bridge_label" >/dev/null 2>&1 || :
else
  if [[ -f "$bridge_pid_file" ]]; then
    bridge_pid="$(<"$bridge_pid_file")"
    if kill -0 "$bridge_pid" 2>/dev/null && [[ "$(ps -p "$bridge_pid" -o command=)" == *"src/ai-bridge.js"* ]]; then
      kill "$bridge_pid"
    fi
    rm -f "$bridge_pid_file"
  fi
fi
if podman container exists floci-duck; then
  sidecar_networks="$(podman inspect floci-duck --format '{{json .NetworkSettings.Networks}}')"
  if [[ "$sidecar_networks" == *"$network_name"* ]]; then
    podman rm -f floci-duck
  fi
fi
podman-compose -f podman-compose.yml down -t 1
