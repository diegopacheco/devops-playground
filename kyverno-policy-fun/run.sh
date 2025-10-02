#!/bin/bash

set -e

echo "Creating kind cluster..."
kind create cluster --name kyverno-cluster --wait 5m

echo "Installing Kyverno..."
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.11.0/install.yaml

echo "Waiting for Kyverno to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/part-of=kyverno -n kyverno --timeout=300s

echo "Waiting for webhooks to be configured..."
until kubectl get validatingwebhookconfigurations kyverno-resource-validating-webhook-cfg 2>/dev/null | grep -q kyverno; do
  echo "Waiting for webhooks..."
  sleep 2
done

echo "Applying Kyverno policies from spec/policies/ folder..."
kubectl apply -f spec/policies/

echo "Waiting for policies to be ready..."
until [ $(kubectl get clusterpolicies -o json | jq -r '.items[] | select(.status.ready == true) | .metadata.name' | wc -l) -eq 4 ]; do
  echo "Waiting for all 4 policies to be ready..."
  sleep 1
done

echo "Cluster is ready!"
kubectl get clusterpolicies
kubectl cluster-info --context kind-kyverno-cluster
