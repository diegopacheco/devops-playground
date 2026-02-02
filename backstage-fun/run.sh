#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT=3000

if lsof -ti :$PORT > /dev/null 2>&1; then
  echo "Port $PORT in use, stopping existing processes..."
  lsof -ti :$PORT | xargs kill -9 2>/dev/null
  sleep 1
fi

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

echo "Getting K8s credentials..."
K8S_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
K8S_TOKEN=$(kubectl get secret backstage-token -n backstage -o jsonpath='{.data.token}' | base64 --decode)

echo "K8S_URL: $K8S_URL"

echo "Opening Backstage in browser..."
sleep 2 && open "http://localhost:$PORT" &

echo "Starting Backstage on port $PORT..."
podman run -it --rm \
  -p $PORT:7000 \
  --add-host=host.docker.internal:host-gateway \
  -v "$SCRIPT_DIR/catalog:/app/catalog:ro" \
  -v "$SCRIPT_DIR/templates:/app/templates:ro" \
  -v "$SCRIPT_DIR/app-config.yaml:/app/app-config.yaml:ro" \
  -e K8S_URL="${K8S_URL/127.0.0.1/host.docker.internal}" \
  -e K8S_TOKEN="$K8S_TOKEN" \
  roadiehq/community-backstage-image:latest
