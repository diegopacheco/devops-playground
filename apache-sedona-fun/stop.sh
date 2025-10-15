#!/bin/bash
set -e

echo "Stopping Flink cluster..."
kubectl delete -f specs/taskmanager.yaml --ignore-not-found=true
kubectl delete -f specs/jobmanager.yaml --ignore-not-found=true
kubectl delete -f specs/configmap.yaml --ignore-not-found=true
kubectl delete -f specs/namespace.yaml --ignore-not-found=true

echo "Deleting kind cluster..."
kind delete cluster --name flink-sedona-cluster

echo "Cluster stopped and cleaned up successfully!"
