#!/bin/bash

set -e

CLUSTER_NAME="nginx-cluster"

echo "Creating Kind cluster: $CLUSTER_NAME"
kind create cluster --name $CLUSTER_NAME

echo "Waiting for cluster to be ready"
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "Applying nginx deployment"
kubectl apply -f specs/deployment.yaml

echo "Applying nginx service"
kubectl apply -f specs/service.yaml

echo "Waiting for deployment to be ready"
kubectl wait --for=condition=Available deployment/nginx-deployment --timeout=120s

echo "Getting pods"
kubectl get pods -l app=nginx

echo "Getting service"
kubectl get svc nginx-service

echo "Starting port-forward on port 8080"
kubectl port-forward svc/nginx-service 8080:80 &
PORT_FORWARD_PID=$!

echo "Port-forward started with PID: $PORT_FORWARD_PID"
echo "nginx is accessible at http://localhost:8080"
echo "To stop port-forward: kill $PORT_FORWARD_PID"