#!/bin/bash

echo "Redeploying Flink with updated configuration..."

echo "Updating ConfigMap..."
kubectl apply -f specs/configmap.yaml

echo "Restarting TaskManagers..."
kubectl delete -f specs/taskmanager.yaml
kubectl apply -f specs/taskmanager.yaml

echo "Waiting for TaskManagers to be ready..."
kubectl wait --for=condition=ready pod -l component=taskmanager -n flink-sedona --timeout=120s

echo "Redeployment complete!"
echo "Check logs with: kubectl logs -n flink-sedona -l component=taskmanager --tail=50"
