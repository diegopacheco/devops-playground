#!/bin/bash
set -e
CLUSTER=argocd-canary
HERE=$(cd "$(dirname "$0")" && pwd)
VER=v$(date +%s)
IMG=canary-app:$VER

export KIND_EXPERIMENTAL_PROVIDER=podman

echo ">>> building $IMG"
podman build --build-arg APP_VERSION=$VER -t $IMG -f "$HERE/app/Containerfile" "$HERE/app"

echo ">>> loading image into kind cluster $CLUSTER"
TAR=/tmp/canary-app-$VER.tar
podman save $IMG -o $TAR
kind load image-archive $TAR --name $CLUSTER
rm -f $TAR

if ! kubectl -n canary-app get rollout canary-app >/dev/null 2>&1; then
  echo ">>> first deploy - applying rollout spec"
  kubectl apply -f "$HERE/spec/rollout.yaml"
  until kubectl -n canary-app get rollout canary-app >/dev/null 2>&1; do sleep 1; done
fi

echo ">>> patching rollout to $IMG (this triggers canary)"
kubectl -n canary-app set image rollout/canary-app app=$IMG
kubectl -n canary-app set env rollout/canary-app APP_VERSION=$VER

echo ""
echo "canary started for $VER"
echo "  steps: 20% -> pause 30s -> 50% -> pause 30s -> 100%"
echo ""
echo "watch progression:"
echo "  kubectl argo rollouts get rollout canary-app -n canary-app --watch"
echo ""
echo "evidence in argocd UI:"
echo "  open https://localhost:8080 (run ./ui.sh)"
echo "  navigate to canary-app rollout - you will see stable + canary ReplicaSets"
