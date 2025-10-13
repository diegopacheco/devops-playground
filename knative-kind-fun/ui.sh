#!/bin/bash
set -e

echo "Exposing Knative service..."
echo ""

SERVICE_URL=$(kubectl get ksvc hello -o jsonpath='{.status.url}')
SERVICE_HOST=$(echo $SERVICE_URL | sed 's|http://||' | sed 's|https://||')

echo "Service URL: $SERVICE_URL"
echo "Service Host: $SERVICE_HOST"
echo ""

echo "Triggering service to scale up..."
kubectl run curl-init --image=curlimages/curl:latest --rm --restart=Never -- curl -s -H "Host: $SERVICE_HOST" http://kourier.kourier-system.svc.cluster.local >/dev/null 2>&1 &

echo "Waiting for application pod to be ready..."
max_wait=60
elapsed=0
POD_NAME=""
while [ $elapsed -lt $max_wait ]; do
  POD_NAME=$(kubectl get pods -l serving.knative.dev/service=hello -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
  if [ -n "$POD_NAME" ]; then
    if kubectl wait --for=condition=ready pod/$POD_NAME --timeout=1s >/dev/null 2>&1; then
      echo "Pod $POD_NAME is ready!"
      break
    fi
  fi
  elapsed=$((elapsed + 1))
  sleep 1
done

if [ -z "$POD_NAME" ]; then
  echo "Failed to find application pod"
  exit 1
fi

echo ""
echo "Starting port-forward on localhost:3000..."
echo ""
echo "Access the service at: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop port-forwarding"
echo ""

kubectl port-forward pod/$POD_NAME 3000:5678
