#!/bin/bash

set -e

echo "Uninstalling Falco..."
helm uninstall falco -n falco --ignore-not-found || true

echo "Deleting falco namespace..."
kubectl delete namespace falco --ignore-not-found=true

echo "Deleting kind cluster..."
kind delete cluster --name falco-cluster

echo "Cleanup complete!"
