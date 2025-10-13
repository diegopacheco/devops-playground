#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name voting-cluster --config kind-config.yaml

echo "Building Docker image..."
podman build -t voting-app:latest .

echo "Saving image to tar..."
podman save voting-app:latest -o voting-app.tar

echo "Loading image into kind..."
kind load image-archive voting-app.tar --name voting-cluster

echo "Cleaning up tar file..."
rm -f voting-app.tar

echo "Deploying with Helm..."
helm install voting-app specs/voting-app

echo "Waiting for Redis pod to be ready..."
while [[ $(kubectl get pods -l app=redis -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
  sleep 1
done

echo "Waiting for voting-app pod to be ready..."
while [[ $(kubectl get pods -l app=voting-app -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
  sleep 1
done

echo "Deployment complete!"
echo "Access the app at: http://localhost:30080"
kubectl get pods
