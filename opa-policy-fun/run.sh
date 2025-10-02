#!/bin/bash

set -e

echo "Creating kind cluster..."
kind create cluster --name opa-cluster --wait 5m

echo "Installing OPA Gatekeeper..."
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.14.0/deploy/gatekeeper.yaml

echo "Waiting for Gatekeeper to be ready..."
echo "Waiting for at least 2 controller pods to be ready..."
until [ $(kubectl get pods -n gatekeeper-system -l control-plane=controller-manager --field-selector=status.phase=Running 2>/dev/null | grep -c "Running") -ge 2 ]; do
  echo "Waiting for controller pods..."
  sleep 1
done
kubectl wait --for=condition=ready pod -l control-plane=audit-controller -n gatekeeper-system --timeout=300s

echo "Waiting for Gatekeeper webhooks to be configured..."
until kubectl get validatingwebhookconfigurations gatekeeper-validating-webhook-configuration 2>/dev/null | grep -q gatekeeper; do
  echo "Waiting for webhooks..."
  sleep 1
done

echo "Applying OPA constraint templates from spec/templates/ folder..."
kubectl apply -f spec/templates/

echo "Waiting for constraint templates to be ready..."
sleep 5

echo "Applying OPA constraints from spec/constraints/ folder..."
kubectl apply -f spec/constraints/

echo "Waiting for constraints to be ready..."
sleep 3

echo "Cluster is ready!"
kubectl get constrainttemplates
echo ""
kubectl get constraints --all-namespaces
kubectl cluster-info --context kind-opa-cluster
