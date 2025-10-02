#!/bin/bash

set -e

echo "Deleting Kyverno policies..."
kubectl delete -f spec/policies/ --ignore-not-found=true

echo "Deleting kind cluster..."
kind delete cluster --name kyverno-cluster

echo "Cleanup complete!"
