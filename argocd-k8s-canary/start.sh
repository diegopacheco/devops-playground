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
kubectl apply -n argo-rollouts --server-side --force-conflicts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/dashboard-install.yaml

echo "waiting for argocd-server..."
until kubectl -n argocd get deploy argocd-server -o jsonpath='{.status.availableReplicas}' 2>/dev/null | grep -q '^[1-9]'; do sleep 1; done

echo "waiting for argo-rollouts controller..."
until kubectl -n argo-rollouts get deploy argo-rollouts -o jsonpath='{.status.availableReplicas}' 2>/dev/null | grep -q '^[1-9]'; do sleep 1; done

echo "waiting for argo-rollouts dashboard..."
until kubectl -n argo-rollouts get deploy argo-rollouts-dashboard -o jsonpath='{.status.availableReplicas}' 2>/dev/null | grep -q '^[1-9]'; do sleep 1; done

echo "registering argocd Application..."
kubectl apply -f "$HERE/spec/argocd-app.yaml"

echo "triggering initial sync (retries on first-clone timeout)..."
kubectl -n argocd patch app canary-app --type=merge -p '{"operation":{"sync":{}}}' >/dev/null
STATUS=""
for i in $(seq 1 120); do
  STATUS=$(kubectl -n argocd get app canary-app -o jsonpath='{.status.sync.status}' 2>/dev/null || echo "")
  if [ "$STATUS" = "Synced" ]; then break; fi
  if [ $((i % 30)) -eq 0 ]; then
    kubectl -n argocd patch app canary-app --type=merge -p '{"operation":{"sync":{}}}' >/dev/null 2>&1 || true
  fi
  sleep 1
done
echo "argocd app status: $STATUS"

echo ""
echo "cluster ready"
echo ""
echo "argocd reads from: github.com/diegopacheco/devops-playground @ master, path argocd-k8s-canary/spec"
echo "if status above is not Synced, push your latest spec/ changes and rerun ./start.sh"
echo ""
echo "next: ./canary.sh         build java app, kind-load, trigger canary"
echo "      ./ui.sh             argocd UI on https://localhost:8080"
echo "      ./ui-rollouts.sh    argo-rollouts dashboard on http://localhost:3100"
