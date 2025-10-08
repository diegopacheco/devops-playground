#!/bin/bash
set -e

MACHINE_NAME=$(podman machine list --format "{{.Name}}" | head -1 | tr -d '*')

if [ -z "$MACHINE_NAME" ]; then
    MACHINE_NAME="podman-machine-default"
    echo "No existing machine found, will create: $MACHINE_NAME"
else
    echo "Current podman machine: $MACHINE_NAME"
    echo "Removing existing podman machine..."
    podman machine rm -f $MACHINE_NAME 2>/dev/null || true
fi

echo "Creating new podman machine with 8GB RAM and 4 CPUs..."
podman machine init --cpus 4 --memory 8192 --disk-size 100 $MACHINE_NAME

echo "Starting podman machine..."
podman machine start $MACHINE_NAME

echo "Podman machine ready with increased resources"
podman machine inspect $MACHINE_NAME | grep -E "(Memory|CPUs|DiskSize)"
