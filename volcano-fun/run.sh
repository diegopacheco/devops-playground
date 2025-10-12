#!/bin/bash
set -e

echo "Creating Kind cluster..."
kind create cluster --name volcano-flink --config specs/kind-config.yaml

echo "Installing Volcano..."
kubectl apply -f https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml

echo "Waiting for Volcano scheduler to be ready..."
while true; do
  STATUS=$(kubectl get pods -n volcano-system -l app=volcano-scheduler -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "NotReady")
  if [ "$STATUS" = "Running" ]; then
    break
  fi
  sleep 1
done

echo "Waiting for Volcano admission to be ready..."
while true; do
  READY=$(kubectl get pods -n volcano-system -l app=volcano-admission -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null || echo "false")
  if [ "$READY" = "true" ]; then
    break
  fi
  sleep 1
done

echo "Waiting for Volcano controller to be ready..."
while true; do
  READY=$(kubectl get pods -n volcano-system -l app=volcano-controller -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null || echo "false")
  if [ "$READY" = "true" ]; then
    break
  fi
  sleep 1
done

echo "Waiting for Volcano admission webhook to be fully operational..."
RETRY=0
while [ $RETRY -lt 30 ]; do
  if kubectl get validatingwebhookconfigurations.admissionregistration.k8s.io volcano-admission-service-jobs-validate >/dev/null 2>&1; then
    echo "Webhook configuration found, waiting 10 seconds for service to stabilize..."
    sleep 10
    break
  fi
  RETRY=$((RETRY+1))
  sleep 1
done

echo "Deploying Flink with Volcano scheduler..."
kubectl apply -f specs/flink-volcano.yaml

echo "Waiting for Flink JobManager to be ready..."
while true; do
  STATUS=$(kubectl get pods -n flink -l component=jobmanager -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "NotReady")
  if [ "$STATUS" = "Running" ]; then
    break
  fi
  sleep 1
done

echo "Waiting for Flink TaskManagers to be ready..."
while true; do
  READY=$(kubectl get pods -n flink -l component=taskmanager -o jsonpath='{.items[*].status.phase}' 2>/dev/null | grep -o "Running" | wc -l | tr -d ' ')
  if [ "$READY" -ge 2 ]; then
    break
  fi
  sleep 1
done

echo "Cluster is ready!"
echo "Flink UI: http://localhost:30080"
echo "Run ./ui.sh to access Volcano UI"
