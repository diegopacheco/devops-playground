#!/bin/bash
set -e

echo "Initial pod count:"
kubectl get pods -l app=rust-webservice
INITIAL_PODS=$(kubectl get pods -l app=rust-webservice -o json | jq '.items | length')
echo "Starting with $INITIAL_PODS pod(s)"

echo "Creating k6 pod for load testing..."
kubectl run k6 --image=grafana/k6:latest --restart=Never --command -- sleep 3600

echo "Waiting for k6 pod to be ready..."
kubectl wait --for=condition=ready pod k6 --timeout=120s

kubectl cp load-test.js k6:/tmp/load-test.js

echo "Starting load test..."
kubectl exec k6 -- k6 run /tmp/load-test.js &

echo "Monitoring pod scaling..."
for i in {1..120}; do
  CURRENT_PODS=$(kubectl get pods -l app=rust-webservice -o json | jq '.items | length')
  CPU_USAGE=$(kubectl top pods -l app=rust-webservice --no-headers 2>/dev/null | awk '{sum+=$2} END {print sum}' || echo "waiting")
  HPA_STATUS=$(kubectl get hpa keda-hpa-rust-webservice-scaler --no-headers 2>/dev/null | awk '{print $4}' || echo "N/A")
  echo "Time: ${i}s - Pods: $CURRENT_PODS - CPU: ${CPU_USAGE} - HPA Target: ${HPA_STATUS}"
  if [ "$CURRENT_PODS" -ge 3 ]; then
    echo "SUCCESS! Scaled to $CURRENT_PODS pods"
    kubectl get pods -l app=rust-webservice
    kubectl get hpa
    kubectl top pods -l app=rust-webservice
    break
  fi
  sleep 1
done

FINAL_PODS=$(kubectl get pods -l app=rust-webservice -o json | jq '.items | length')
echo "Final pod count: $FINAL_PODS"

if [ "$FINAL_PODS" -ge 3 ]; then
  echo "KEDA autoscaling verified: scaled from $INITIAL_PODS to $FINAL_PODS pods"
else
  echo "WARNING: Expected 3 pods, got $FINAL_PODS"
fi

echo "Cleaning up k6 pod..."
kubectl delete pod k6 --force --grace-period=0
