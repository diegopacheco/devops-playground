#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name headlamp-cluster --image kindest/node:v1.31.0

echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=180s

echo "Deploying Headlamp..."
kubectl apply -f spec/headlamp.yaml

echo "Deploying sample applications..."
kubectl apply -f spec/sample-apps.yaml

echo "Waiting for Headlamp pod to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
  pod_status=$(kubectl get pods -n headlamp -l app=headlamp -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "NotFound")
  if [ "$pod_status" = "Running" ]; then
    ready=$(kubectl get pods -n headlamp -l app=headlamp -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null || echo "false")
    if [ "$ready" = "true" ]; then
      echo "Headlamp is ready!"
      break
    fi
  fi
  echo "Waiting for Headlamp pod... (attempt $((attempt + 1))/$max_attempts)"
  sleep 1
  attempt=$((attempt + 1))
done

echo "Waiting for sample apps to be ready..."
kubectl wait --for=condition=Available deployment/nginx-deployment -n demo-apps --timeout=120s
kubectl wait --for=condition=Available deployment/redis-deployment -n demo-apps --timeout=120s

echo ""
echo "Cluster is ready!"
echo "Run ./test.sh to access Headlamp UI"
