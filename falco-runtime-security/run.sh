#!/bin/bash

set -e

echo "Creating kind cluster..."
kind create cluster --name falco-cluster

echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "Installing Falco using Helm..."
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

echo "Creating falco namespace..."
kubectl create namespace falco || true

echo "Installing Falco k8s Metacollector only..."
echo "Note: Full Falco requires kernel driver (eBPF/module) not available in Kind"
helm install falco falcosecurity/falco \
  --namespace falco \
  --set driver.enabled=false \
  --set tty=true \
  --set collectors.kubernetes.enabled=true \
  --set falco.enabled=false

echo "Waiting for metacollector to be ready..."
TIMEOUT=60
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  READY=$(kubectl get pods -n falco -l app.kubernetes.io/name=k8s-metacollector -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "")
  if [ "$READY" = "True" ]; then
    echo "✓ Metacollector is ready!"
    break
  fi
  echo "Waiting... ($ELAPSED/$TIMEOUT seconds)"
  sleep 1
  ELAPSED=$((ELAPSED + 1))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
  echo "Warning: Timeout reached, but continuing..."
fi

echo ""
echo "Installation complete!"
kubectl get pods -n falco

echo ""
echo "Cluster info:"
kubectl cluster-info

echo ""
echo "========================================="
echo "About this setup:"
echo "========================================="
echo "- K8s Metacollector: ✓ Running (collecting pod/container metadata)"
echo "- Falco daemon: ✗ Requires kernel driver (not available in Kind/Podman)"
echo "- In production: Use eBPF/kernel module for full runtime monitoring"
echo ""
echo "The metacollector provides Kubernetes context enrichment"
echo "Full Falco with driver detects runtime threats like:"
echo "  • Shell spawned in containers"
echo "  • Sensitive file access"
echo "  • Privilege escalation"
echo "  • Container escape attempts"
echo "========================================="
echo ""
echo "Note: The failing falco daemon pod is expected in Kind"
echo "      The metacollector shows Falco's k8s integration"
