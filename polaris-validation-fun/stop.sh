#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name polaris-validation

echo "Cleaning up Polaris CLI binary..."
if [ -f "./polaris" ]; then
  rm -f ./polaris
fi

echo "Cleanup complete!"
