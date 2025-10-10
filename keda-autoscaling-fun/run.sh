#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name keda-cluster

echo "Building Docker image..."
podman build -t rust-webservice:latest .

echo "Saving image to tar..."
podman save -o /tmp/rust-webservice.tar localhost/rust-webservice:latest

echo "Loading image into kind..."
kind load image-archive /tmp/rust-webservice.tar --name keda-cluster

echo "Cleaning up tar file..."
rm -f /tmp/rust-webservice.tar

echo "Deploying application..."
kubectl apply -f specs/deployment.yaml
kubectl apply -f specs/service.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/rust-webservice --timeout=120s

echo "Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.2/components.yaml

echo "Patching metrics-server for kind..."
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

echo "Waiting for metrics-server to be ready..."
sleep 10
while [ $(kubectl get pods -n kube-system -l k8s-app=metrics-server -o jsonpath='{.items[0].status.phase}' 2>/dev/null) != "Running" ]; do
  echo "Waiting for metrics-server pod..."
  sleep 1
done
echo "Metrics-server is running!"

echo "Installing KEDA..."
kubectl apply --server-side -f https://github.com/kedacore/keda/releases/download/v2.15.1/keda-2.15.1.yaml

echo "Waiting for KEDA to be ready..."
kubectl wait --for=condition=ready pod -l app=keda-operator -n keda --timeout=300s
kubectl wait --for=condition=ready pod -l app=keda-metrics-apiserver -n keda --timeout=300s
kubectl wait --for=condition=ready pod -l app=keda-admission-webhooks -n keda --timeout=300s

echo "KEDA installed successfully!"
kubectl get pods -n keda

echo "Applying ScaledObject..."
kubectl apply -f specs/scaledobject.yaml

echo "Deployment complete!"
kubectl get pods
