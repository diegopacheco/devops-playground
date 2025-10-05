#!/bin/bash

set -e

echo "Creating kind cluster..."
kind create cluster --name vault-k8s --config kind-config.yaml

echo "Setting kubectl context..."
kubectl config use-context kind-vault-k8s

echo "Installing Vault..."
bash vault-setup.sh

echo "Building application image..."
podman build -t myapp:latest .

echo "Saving image to tar..."
podman save -o /tmp/myapp.tar localhost/myapp:latest

echo "Loading image into kind cluster..."
kind load image-archive /tmp/myapp.tar --name vault-k8s

echo "Cleaning up tar file..."
rm -f /tmp/myapp.tar

echo "Deploying application..."
kubectl apply -f specs/service-account.yaml
kubectl apply -f specs/deployment.yaml
kubectl apply -f specs/service.yaml

echo "Waiting for myapp pod to be ready..."
for i in {1..60}; do
  if kubectl get pods -l app=myapp -o jsonpath='{.items[0].status.phase}' 2>/dev/null | grep -q Running; then
    echo "Application pod is running"
    break
  fi
  sleep 1
done

kubectl wait --for=condition=ready pod -l app=myapp --timeout=120s

echo ""
echo "Setup complete!"
echo "Application is accessible at: http://localhost:8080"
echo "Vault UI is accessible at: http://localhost:8200 (token: root)"
echo ""
echo "Run ./test.sh to test the application"
