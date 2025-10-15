#!/bin/bash
set -e

echo "Starting port-forward to Flink JobManager UI..."
echo "Access the UI at: http://localhost:8081"
echo "Press Ctrl+C to stop port-forwarding"
echo ""
kubectl port-forward -n flink-sedona svc/flink-jobmanager 8081:8081
