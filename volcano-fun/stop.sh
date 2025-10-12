#!/bin/bash
set -e

echo "Deleting Kind cluster..."
kind delete cluster --name volcano-flink

echo "Cluster deleted successfully!"
