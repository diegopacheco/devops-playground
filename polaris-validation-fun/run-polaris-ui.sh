#!/bin/bash
set -e

echo "Checking if Polaris is deployed..."
if ! kubectl get deployment -n polaris polaris-dashboard &>/dev/null; then
  echo "Polaris not found. Run ./run.sh first"
  exit 1
fi

echo "Starting port-forward to Polaris dashboard..."
echo ""
echo "Polaris UI is available at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward -n polaris svc/polaris-dashboard 8080:80
