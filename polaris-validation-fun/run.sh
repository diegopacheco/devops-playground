#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name polaris-validation

echo "Waiting for nodes to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
  if kubectl get nodes | grep -q "Ready"; then
    echo "Nodes are ready"
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

echo "Adding Helm repo..."
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm repo update

echo "Installing Polaris..."
helm upgrade --install polaris fairwinds-stable/polaris --namespace polaris --create-namespace

echo "Waiting for Polaris deployment..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
  if kubectl get deployment -n polaris polaris-dashboard &>/dev/null; then
    if [ "$(kubectl get deployment -n polaris polaris-dashboard -o jsonpath='{.status.readyReplicas}')" == "1" ]; then
      echo "Polaris is ready"
      break
    fi
  fi
  attempt=$((attempt + 1))
  sleep 1
done

echo "Deploying test applications..."
kubectl apply -f specs/bad-deployment.yaml
kubectl apply -f specs/good-deployment.yaml

echo "Waiting for deployments..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
  bad_ready=$(kubectl get deployment bad-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
  good_ready=$(kubectl get deployment good-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
  if [ "$bad_ready" == "1" ] && [ "$good_ready" == "1" ]; then
    echo "Deployments are ready"
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

echo "Setup complete!"
echo "Access Polaris dashboard with: kubectl port-forward -n polaris svc/polaris-dashboard 8080:80"
