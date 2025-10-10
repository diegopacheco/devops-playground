#!/bin/bash
set -e

echo "Checking Atlantis pod status..."
kubectl get pods -n atlantis -l app=atlantis

ATLANTIS_POD=$(kubectl get pods -n atlantis -l app=atlantis -o jsonpath='{.items[0].metadata.name}')

if [ -z "$ATLANTIS_POD" ]; then
  echo "Atlantis pod not found. Make sure the cluster is running."
  exit 1
fi

echo "Atlantis is running in pod: $ATLANTIS_POD"
echo "Port-forwarding to Atlantis UI..."
echo "Access Atlantis at: http://localhost:4141"
echo "Press Ctrl+C to stop port forwarding"

kubectl port-forward -n atlantis svc/atlantis 4141:4141
