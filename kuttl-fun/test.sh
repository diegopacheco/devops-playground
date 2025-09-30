#!/bin/bash
set -e

echo "Running kuttl tests..."
kubectl kuttl test --config kuttl-test.yaml