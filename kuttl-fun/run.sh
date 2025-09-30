#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name kuttl-test --wait 5m

echo "Applying Kubernetes specs..."
kubectl apply -f specs/

echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/nginx-deployment

echo "Cluster is ready!"
kubectl get pods
kubectl get services