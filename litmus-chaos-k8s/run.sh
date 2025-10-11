#!/bin/bash
set -e

CLUSTER_NAME="litmus-chaos"

echo "Creating Kind cluster: ${CLUSTER_NAME}"
kind create cluster --name ${CLUSTER_NAME}

echo "Waiting for cluster to be ready"
while ! kubectl cluster-info &> /dev/null; do
  sleep 1
done

echo "Applying namespace"
kubectl apply -f specs/00-namespace.yaml

echo "Adding MongoDB Helm repository"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo "Installing MongoDB"
helm install my-release bitnami/mongodb --namespace litmus --set architecture=replicaset --set replicaCount=1 --set auth.rootUser=root --set-string auth.rootPassword=1234

echo "Waiting for MongoDB pods to be created"
while [ $(kubectl get pods -n litmus -l app.kubernetes.io/name=mongodb 2>/dev/null | grep -v "NAME" | wc -l) -eq 0 ]; do
  sleep 1
done

echo "Waiting for MongoDB to be ready"
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=mongodb -n litmus --timeout=300s

echo "Applying Litmus Chaos manifest"
kubectl apply -f specs/litmus-getting-started.yaml -n litmus

echo "Applying nginx deployment"
kubectl apply -f specs/nginx-deployment.yaml

echo "Waiting for Litmus pods to be ready"
kubectl wait --for=condition=Ready pods -l component=litmusportal-frontend -n litmus --timeout=300s
kubectl wait --for=condition=Ready pods -l component=litmusportal-server -n litmus --timeout=300s
kubectl wait --for=condition=Ready pods -l component=litmusportal-auth-server -n litmus --timeout=300s

echo "Waiting for nginx pods to be ready"
kubectl wait --for=condition=Ready pods -l app=nginx -n litmus --timeout=300s

echo "Cluster ready!"
echo "All pods in litmus namespace:"
kubectl get pods -n litmus

echo ""
echo "To access Litmus UI, run: ./ui.sh"
