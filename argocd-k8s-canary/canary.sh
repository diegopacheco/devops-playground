#!/bin/bash
set -e
CLUSTER=argocd-canary
HERE=$(cd "$(dirname "$0")" && pwd)
VER=v$(date +%s)
IMG=localhost/canary-app:$VER

export KIND_EXPERIMENTAL_PROVIDER=podman

echo ">>> building $IMG"
podman build --build-arg APP_VERSION=$VER -t $IMG -f "$HERE/app/Containerfile" "$HERE/app"

echo ">>> loading image into kind cluster $CLUSTER"
TAR=/tmp/canary-app-$VER.tar
podman save $IMG -o $TAR
kind load image-archive $TAR --name $CLUSTER
rm -f $TAR

echo ">>> waiting for rollout (managed by argocd) to exist..."
until kubectl -n canary-app get rollout canary-app >/dev/null 2>&1; do sleep 1; done

echo ">>> patching rollout image to $IMG"
kubectl -n canary-app patch rollout canary-app --type=json -p "[
  {\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/image\",\"value\":\"$IMG\"},
  {\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/env/0/value\",\"value\":\"$VER\"}
]"

echo ""
echo "deployed $VER"
echo "  first run = baseline (no canary, no stable RS yet)"
echo "  re-run    = canary: 20% -> pause 30s -> 50% -> pause 30s -> 100%"
echo ""
echo "watch:    kubectl -n canary-app get rollout canary-app -w"
echo "argocd:   ./ui.sh           https://localhost:8080"
echo "rollouts: ./ui-rollouts.sh  http://localhost:3100/rollouts"
