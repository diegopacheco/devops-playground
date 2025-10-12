#!/bin/bash

echo "====================================="
echo "Volcano System Status"
echo "====================================="
echo ""
echo "Volcano Pods:"
kubectl get pods -n volcano-system
echo ""
echo "====================================="
echo "Volcano Jobs:"
kubectl get vcjob -n flink
echo ""
echo "====================================="
echo "Volcano Queues:"
kubectl get queue
echo ""
echo "====================================="
echo "Flink Pods:"
kubectl get pods -n flink
echo ""
echo "====================================="
echo "Flink UI: http://localhost:30080"
echo "====================================="
