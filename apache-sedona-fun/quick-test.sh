#!/bin/bash
set -e

echo "=== Quick Test - Submitting Sedona Job ==="

JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')

if [ -z "$JOBMANAGER_POD" ]; then
    echo "Error: JobManager pod not found!"
    exit 1
fi

echo "JobManager: $JOBMANAGER_POD"
echo "Starting timer..."
START_TIME=$(date +%s)

kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "=========================================="
echo "Job completed in ${ELAPSED} seconds!"
echo "Target: under 20 seconds"
echo "=========================================="

if [ $ELAPSED -le 20 ]; then
    echo "✅ SUCCESS! Job completed within target time."
else
    echo "⚠️  Job took longer than 20 seconds."
fi

echo ""
echo "View JobManager UI: http://localhost:30081"
echo "Check logs: kubectl logs -n flink-sedona $JOBMANAGER_POD --tail=50"
