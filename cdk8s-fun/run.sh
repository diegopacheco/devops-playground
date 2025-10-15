#!/bin/bash

echo "Creating Kind cluster..."

# Create Kind cluster with custom configuration
kind create cluster --name cdk8s-cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
EOF

echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

kubectl cluster-info --context kind-cdk8s-cluster

echo "Kind cluster created successfully!"
echo "Cluster name: cdk8s-cluster"
echo "Context: kind-cdk8s-cluster"
