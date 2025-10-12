#!/bin/bash
set -e

echo "Submitting Flink batch WordCount job via Volcano..."
kubectl apply -f job/flink-wordcount-job.yaml

echo ""
echo "Waiting for job to start..."
sleep 3

echo ""
echo "Job status:"
kubectl get vcjob -n flink flink-batch-wordcount

echo ""
echo "Job pods:"
kubectl get pods -n flink -l volcano.sh/job-name=flink-batch-wordcount

echo ""
echo "To check job logs:"
echo "kubectl logs -n flink -l volcano.sh/job-name=flink-batch-wordcount -f"

echo ""
echo "To check Flink jobs:"
echo "kubectl port-forward -n flink svc/flink-jobmanager 8081:8081"
echo "Then visit: http://localhost:8081"

echo ""
echo "To delete the job:"
echo "kubectl delete vcjob -n flink flink-batch-wordcount"
