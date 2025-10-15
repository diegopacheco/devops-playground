#!/bin/bash
set -e

echo "Creating kind cluster..."
kind create cluster --name flink-sedona-cluster --wait 5m

echo "Building Docker image..."
podman build -t flink-sedona:latest .

echo "Saving image to tar..."
podman save -o /tmp/flink-sedona.tar localhost/flink-sedona:latest

echo "Loading image into kind cluster..."
kind load image-archive /tmp/flink-sedona.tar --name flink-sedona-cluster

echo "Cleaning up tar file..."
rm -f /tmp/flink-sedona.tar

echo "Deploying Flink with Sedona to Kubernetes..."
kubectl apply -f specs/namespace.yaml
kubectl apply -f specs/configmap.yaml
kubectl apply -f specs/jobmanager.yaml
kubectl apply -f specs/taskmanager.yaml

echo "Waiting for JobManager to be ready..."
while [ "$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
  sleep 1
done

echo "Waiting for TaskManagers to be ready..."
while [ "$(kubectl get pods -n flink-sedona -l component=taskmanager -o jsonpath='{.items[*].status.phase}' | grep -o Running | wc -l)" -lt 2 ]; do
  sleep 1
done

echo "Flink cluster with Apache Sedona is ready!"
echo "JobManager UI: http://localhost:30081"
kubectl get pods -n flink-sedona
