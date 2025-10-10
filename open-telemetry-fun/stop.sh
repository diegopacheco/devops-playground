#!/bin/bash
set -e
echo "Deleting kind cluster..."
kind delete cluster --name otel-cluster
echo "Cluster deleted successfully!"
