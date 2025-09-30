#!/bin/bash
set -e

echo "Deleting kind cluster..."
kind delete cluster --name kuttl-test

echo "Cluster deleted successfully!"