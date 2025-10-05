#!/bin/bash

echo "Deleting kind cluster..."
kind delete cluster --name vault-k8s

echo "Cluster deleted successfully"
