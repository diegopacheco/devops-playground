#!/bin/bash
set -e

echo "Testing Apache Sedona spatial queries on Flink..."
echo "Submitting Flink job with Sedona queries..."

JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')

echo ""
echo "Submitting Sedona query job to Flink..."
kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar

echo ""
echo "Job submitted! Check the JobManager logs for query results."
echo "You can view logs with: kubectl logs -n flink-sedona $JOBMANAGER_POD"
