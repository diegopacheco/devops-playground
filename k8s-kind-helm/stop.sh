#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name voting-cluster

echo "Cluster deleted successfully!"
