#!/bin/bash
set -e

echo "Stopping port-forward processes..."
pkill -f "kubectl port-forward" || true

echo "Deleting Kubernetes resources..."
kubectl delete -f specs/service.yaml --ignore-not-found=true
kubectl delete -f specs/deployment.yaml --ignore-not-found=true

echo "Deleting Kind cluster..."
kind delete cluster --name nginx-cluster

echo "Cleanup complete!"