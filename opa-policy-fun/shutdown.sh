#!/bin/bash

set -e

echo "Deleting OPA constraints..."
kubectl delete -f spec/constraints/ --ignore-not-found=true

echo "Deleting OPA constraint templates..."
kubectl delete -f spec/templates/ --ignore-not-found=true

echo "Deleting kind cluster..."
kind delete cluster --name opa-cluster

echo "Cleanup complete!"
