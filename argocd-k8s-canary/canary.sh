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

echo ">>> applying rollout with image=$IMG"
sed -e "s|image: canary-app:v1|image: $IMG|" \
    -e "s|value: v1|value: $VER|" \
    "$HERE/spec/rollout.yaml" | kubectl apply -f -

echo ""
echo "deployed $VER"
echo "  first run = baseline (no canary)"
echo "  re-run    = triggers canary: 20% -> pause 30s -> 50% -> pause 30s -> 100%"
echo ""
echo "watch progression:"
echo "  kubectl argo rollouts get rollout canary-app -n canary-app --watch"
echo ""
echo "evidence in argocd UI:  run ./ui.sh and open https://localhost:8080"
