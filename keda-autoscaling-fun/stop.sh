#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name keda-cluster

echo "Cluster deleted successfully!"
