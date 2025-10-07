#!/bin/bash
set -e

echo "Checking cluster status..."
kubectl get nodes
echo ""

echo "Checking Headlamp deployment..."
kubectl get pods -n headlamp
echo ""

echo "Checking sample applications..."
kubectl get pods -n demo-apps
echo ""

echo "Headlamp UI available at: http://localhost:8080"
echo "Starting port-forward..."
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward -n headlamp service/headlamp 8080:80
