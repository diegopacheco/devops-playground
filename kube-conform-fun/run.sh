#!/bin/bash
set -e

echo "Creating Kind cluster..."
kind create cluster --name nginx-cluster

echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

echo "Applying deployment..."
kubectl apply -f specs/deployment.yaml

echo "Applying service..."
kubectl apply -f specs/service.yaml

echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/nginx-deployment

echo "Starting port-forward on port 8080..."
kubectl port-forward service/nginx-service 8080:80 &

echo "Cluster is ready! Access nginx at http://localhost:8080"
echo "Run 'kubectl get pods' to see running pods"