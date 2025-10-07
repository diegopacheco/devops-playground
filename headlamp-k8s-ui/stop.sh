#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name headlamp-cluster

echo "Cluster deleted successfully!"
