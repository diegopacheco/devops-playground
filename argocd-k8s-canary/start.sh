#!/bin/bash
set -e
CLUSTER=argocd-canary
HERE=$(cd "$(dirname "$0")" && pwd)

if ! command -v kind >/dev/null 2>&1; then echo "kind not installed"; exit 1; fi
if ! command -v kubectl >/dev/null 2>&1; then echo "kubectl not installed"; exit 1; fi
if ! command -v podman >/dev/null 2>&1; then echo "podman not installed"; exit 1; fi

export KIND_EXPERIMENTAL_PROVIDER=podman

if ! kind get clusters | grep -q "^${CLUSTER}$"; then
  kind create cluster --name $CLUSTER --config "$HERE/spec/kind-config.yaml"
fi

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl create namespace argo-rollouts --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argo-rollouts --server-side --force-conflicts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

kubectl apply -f "$HERE/spec/namespace.yaml"
kubectl apply -f "$HERE/spec/service.yaml"

echo "waiting for argocd-server..."
until kubectl -n argocd get deploy argocd-server -o jsonpath='{.status.availableReplicas}' 2>/dev/null | grep -q '^[1-9]'; do sleep 1; done

echo "waiting for argo-rollouts controller..."
until kubectl -n argo-rollouts get deploy argo-rollouts -o jsonpath='{.status.availableReplicas}' 2>/dev/null | grep -q '^[1-9]'; do sleep 1; done

echo ""
echo "cluster ready"
echo "next: ./canary.sh   (builds java app, kind-loads it, deploys rollout)"
echo "then: ./ui.sh       (port-forward argocd + rollouts dashboard)"
