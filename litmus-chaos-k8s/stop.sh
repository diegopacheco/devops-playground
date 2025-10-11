#!/bin/bash
set -e

CLUSTER_NAME="litmus-chaos"

echo "Deleting Kind cluster: ${CLUSTER_NAME}"
kind delete cluster --name ${CLUSTER_NAME}

echo "Cluster deleted successfully"
