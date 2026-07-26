#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"
if machine_uid="$(podman machine ssh 'id -u' 2>/dev/null)"; then
  export PODMAN_SOCKET_PATH="/run/user/${machine_uid}/podman/podman.sock"
else
  export PODMAN_SOCKET_PATH="${XDG_RUNTIME_DIR}/podman/podman.sock"
fi
./start.sh
podman-compose -f podman-compose.yml exec -T app npm test
