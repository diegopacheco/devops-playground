#!/bin/bash
set -e

echo "Submitting Spark Pi job via Volcano queue: spark-queue..."

if kubectl get vcjob -n default spark-pi-simple >/dev/null 2>&1; then
  echo "Deleting existing job..."
  kubectl delete vcjob -n default spark-pi-simple
  sleep 2
fi

kubectl apply -f job/spark-pi-simple.yaml

echo ""
echo "Waiting for job to start..."
sleep 3

echo ""
echo "Job status:"
kubectl get vcjob -n default spark-pi-simple

echo ""
echo "Job pods:"
kubectl get pods -n default -l volcano.sh/job-name=spark-pi-simple

echo ""
echo "To check job logs:"
echo "kubectl logs -n default -l volcano.sh/job-name=spark-pi-simple -f"

echo ""
echo "To check queue status:"
echo "kubectl get queue spark-queue -o yaml"

echo ""
echo "To delete the job:"
echo "kubectl delete vcjob -n default spark-pi-simple"
