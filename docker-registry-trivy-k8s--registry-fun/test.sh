#!/bin/bash
set -e

REGISTRY_URL="localhost:30500"

echo "Testing Docker Registry..."
echo ""

echo "1. Checking registry API..."
curl -s http://${REGISTRY_URL}/v2/
echo ""

echo "2. Pulling test image..."
podman pull docker.io/library/alpine:latest

echo ""
echo "3. Tagging image for local registry..."
podman tag docker.io/library/alpine:latest ${REGISTRY_URL}/alpine:latest

echo ""
echo "4. Pushing image to registry..."
podman push ${REGISTRY_URL}/alpine:latest --tls-verify=false

echo ""
echo "5. Listing images in registry..."
curl -s http://${REGISTRY_URL}/v2/_catalog

echo ""
echo "6. Listing tags for alpine..."
curl -s http://${REGISTRY_URL}/v2/alpine/tags/list

echo ""
echo "7. Security scanning alpine image..."
./scan.sh alpine:latest

echo ""
echo "Registry is working!"
echo "Registry endpoint: http://${REGISTRY_URL}"
echo "Security scanning available via: ./scan.sh <image>"
echo ""
