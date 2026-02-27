#!/bin/bash

set -e

if [ ! -f buildkit-output.tar.gz ]; then
  echo "buildkit-output.tar.gz not found. Run build.sh first."
  exit 1
fi

if ! command -v podman &> /dev/null; then
  echo "podman not found. Install it first."
  exit 1
fi

echo "Loading tar.gz into podman..."
gunzip -k -f buildkit-output.tar.gz
podman load -i buildkit-output.tar

IMAGE_ID=$(podman images --format "{{.ID}}" | head -1)
podman tag $IMAGE_ID buildkit-poc:latest 2>/dev/null || true

echo "Running container with podman..."
podman run --rm buildkit-poc:latest cat /hello.txt

rm -f buildkit-output.tar
