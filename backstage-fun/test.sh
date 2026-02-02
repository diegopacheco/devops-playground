#!/bin/bash

echo "Checking Kind cluster..."
kind get clusters

echo ""
echo "Checking pods..."
kubectl get pods -A

echo ""
echo "Checking services..."
kubectl get svc -A

echo ""
echo "Testing Backstage..."
curl -s http://localhost:3000/api/catalog/entities?filter=kind=component | head -c 500

echo ""
echo "Done."
