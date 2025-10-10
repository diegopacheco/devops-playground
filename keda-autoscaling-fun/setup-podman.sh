#!/bin/bash
set -e

MACHINE_NAME="podman-machine-default"
CPUS=4
MEMORY=8192

echo "Stopping existing podman machine..."
podman machine stop $MACHINE_NAME || true

echo "Removing existing podman machine..."
podman machine rm -f $MACHINE_NAME || true

echo "Creating new podman machine with $CPUS CPUs and ${MEMORY}MB memory..."
podman machine init --cpus $CPUS --memory $MEMORY --disk-size 50 $MACHINE_NAME

echo "Starting podman machine..."
podman machine start $MACHINE_NAME

echo "Podman machine configured successfully!"
podman machine info
