#!/bin/bash

set -e

if ! command -v buildctl &> /dev/null; then
  echo "buildctl not found. Installing via brew..."
  brew install buildkit
fi

if ! command -v limactl &> /dev/null; then
  echo "lima not found. Installing via brew..."
  brew install lima
fi

if ! limactl list | grep -q "buildkit.*Running"; then
  echo "Starting lima buildkit VM..."
  limactl start template://buildkit 2>/dev/null || true
  sleep 1
fi

export BUILDKIT_HOST="unix://$HOME/.lima/buildkit/sock/buildkitd.sock"

echo "Building with BuildKit (oci image tar.gz)..."
buildctl build \
  --frontend dockerfile.v0 \
  --local context=. \
  --local dockerfile=. \
  --opt filename=Containerfile \
  --output type=oci,dest=./buildkit-output.tar

gzip -f ./buildkit-output.tar

echo "Build complete: buildkit-output.tar.gz"
ls -lh buildkit-output.tar.gz
