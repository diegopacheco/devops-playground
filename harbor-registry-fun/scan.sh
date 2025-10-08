#!/bin/bash
set -e
IMAGE=${1:-alpine:latest}
echo "Security scanning: $IMAGE"
kubectl delete pod trivy-scan -n harbor 2>/dev/null || true
kubectl run trivy-scan --rm -i --restart=Never --image=aquasec/trivy:latest -n harbor -- image --server http://trivy-server:8080 $IMAGE
