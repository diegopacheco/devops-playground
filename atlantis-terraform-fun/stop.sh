#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name atlantis-cluster

echo "Cluster deleted successfully"
