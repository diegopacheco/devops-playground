#!/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

echo "Deleting kind cluster..."
kind delete cluster --name harbor-cluster

echo "Cleaning up podman containers..."
podman ps -a | grep harbor-cluster | awk '{print $1}' | xargs -r podman rm -f 2>/dev/null || true

echo "Cluster deleted successfully"
