#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! kind get clusters 2>/dev/null | grep -q backstage-cluster; then
  echo "Creating Kind cluster..."
  kind create cluster --config "$SCRIPT_DIR/kind-config.yaml"
fi

kubectl config use-context kind-backstage-cluster

echo "Applying Kubernetes resources..."
kubectl apply -f "$SCRIPT_DIR/k8s/backstage-sa.yaml"
kubectl apply -f "$SCRIPT_DIR/k8s/services.yaml"

echo "Waiting for pods..."
while [ "$(kubectl get pods -n default -o jsonpath='{.items[*].status.phase}' | tr ' ' '\n' | grep -v Running | wc -l)" -gt 0 ]; do
  kubectl get pods -n default
  sleep 1
done

echo "Starting kubectl proxy..."
kubectl proxy --port=8001 &
PROXY_PID=$!

echo "Starting Backstage..."
podman run -it --rm \
  -p 7007:7007 \
  --network host \
  -v "$SCRIPT_DIR/catalog:/app/catalog:ro" \
  -v "$SCRIPT_DIR/templates:/app/templates:ro" \
  -v "$SCRIPT_DIR/app-config.yaml:/app/app-config.local.yaml:ro" \
  -e APP_CONFIG_app_baseUrl=http://localhost:7007 \
  -e APP_CONFIG_backend_baseUrl=http://localhost:7007 \
  roadiehq/community-backstage-image:latest

kill $PROXY_PID 2>/dev/null
