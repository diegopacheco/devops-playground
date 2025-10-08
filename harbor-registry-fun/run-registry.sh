#!/bin/bash
set -e

if ! command -v podman &> /dev/null; then
    echo "Podman not found. Please install podman."
    exit 1
fi

if ! podman info &> /dev/null; then
    echo "Podman is not running properly."
    exit 1
fi

MACHINE_STATUS=$(podman machine list --format "{{.Running}}" 2>/dev/null | head -1)
if [ "$MACHINE_STATUS" != "true" ]; then
    echo "Starting podman machine..."
    podman machine start
    for i in {1..30}; do
        if podman info &> /dev/null; then
            echo "Podman machine started"
            break
        fi
        sleep 1
    done
fi

export KIND_EXPERIMENTAL_PROVIDER=podman

echo "Creating kind cluster..."
kind create cluster --config=spec/kind-config.yaml --retain

echo "Waiting for cluster to be ready..."
for i in {1..120}; do
  if kubectl cluster-info &> /dev/null; then
    echo "Cluster is ready"
    break
  fi
  echo "Waiting for cluster... ($i/120)"
  sleep 1
done

if ! kubectl cluster-info &> /dev/null; then
    echo "Cluster failed to start. Check podman machine status."
    exit 1
fi

echo "Creating namespace..."
kubectl apply -f spec/namespace.yaml

echo "Deploying Docker Registry..."
kubectl apply -f spec/docker-registry.yaml

echo "Waiting for registry pod to be ready..."
for i in {1..60}; do
  READY=$(kubectl get pods -n harbor -l app=docker-registry -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null | grep -o "True" | wc -l)
  if [ "$READY" -ge 1 ]; then
    echo "Docker Registry is ready"
    break
  fi
  echo "Waiting for registry... ($i/60)"
  sleep 1
done

echo "Waiting for registry UI pod to be ready..."
for i in {1..60}; do
  READY=$(kubectl get pods -n harbor -l app=registry-ui -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null | grep -o "True" | wc -l)
  if [ "$READY" -ge 1 ]; then
    echo "Registry UI is ready"
    break
  fi
  echo "Waiting for UI... ($i/60)"
  sleep 1
done

echo ""
echo "Docker Registry is running!"
echo "Registry endpoint: localhost:30500"
echo "Registry UI: http://localhost:30080"
echo ""
echo "Push an image:"
echo "  podman tag myimage:latest localhost:30500/myimage:latest"
echo "  podman push localhost:30500/myimage:latest --tls-verify=false"
echo ""
echo "Open UI with: ./ui.sh"
echo ""
