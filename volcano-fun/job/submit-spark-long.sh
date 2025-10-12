#!/bin/bash
set -e

echo "Submitting long-running Spark Pi job for UI demo..."
echo "This job runs 100,000 iterations and takes several minutes"
echo ""

if kubectl get vcjob -n default spark-long-running >/dev/null 2>&1; then
  echo "Deleting existing job..."
  kubectl delete vcjob -n default spark-long-running
  sleep 2
fi

kubectl apply -f job/spark-streaming-ui.yaml

echo ""
echo "Waiting for job to start..."
sleep 5

echo ""
echo "Job status:"
kubectl get vcjob -n default spark-long-running

echo ""
echo "Job pods:"
kubectl get pods -n default -l volcano.sh/job-name=spark-long-running

echo ""
echo "Once the pod is Running, access Spark UI with:"
echo "  ./spark-ui.sh"
echo ""
echo "To check job logs:"
echo "  kubectl logs -n default -l volcano.sh/job-name=spark-long-running -f"
echo ""
echo "To delete the job:"
echo "  kubectl delete vcjob -n default spark-long-running"
