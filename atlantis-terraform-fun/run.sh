#!/bin/bash
set -e

kind create cluster --name atlantis-cluster --wait 5m

kubectl cluster-info --context kind-atlantis-cluster

mkdir -p specs
mkdir -p terraform

kubectl create namespace atlantis 2>/dev/null || true

kubectl apply -f specs/

echo "Waiting for Atlantis pod to be ready..."
while [ "$(kubectl get pods -n atlantis -l app=atlantis -o jsonpath='{.items[0].status.phase}' 2>/dev/null)" != "Running" ]; do
  sleep 1
done

echo "Cluster created and Atlantis deployed successfully"
kubectl get pods -n atlantis
kubectl get svc -n atlantis
