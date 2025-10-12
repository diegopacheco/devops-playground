#!/bin/bash

echo "====================================="
echo "Volcano System Status"
echo "====================================="
echo ""
echo "Volcano Pods:"
kubectl get pods -n volcano-system
echo ""
echo "====================================="
echo "Volcano Queues:"
kubectl get queue
echo ""
echo "Queue Details:"
kubectl get queue -o custom-columns=NAME:.metadata.name,WEIGHT:.spec.weight,CAPACITY-CPU:.spec.capability.cpu,CAPACITY-MEM:.spec.capability.memory,RECLAIMABLE:.spec.reclaimable
echo ""
echo "====================================="
echo "Volcano Jobs (all namespaces):"
kubectl get vcjob --all-namespaces
echo ""
echo "====================================="
echo "Flink Pods:"
kubectl get pods -n flink
echo ""
echo "====================================="
echo "Spark Pods:"
kubectl get pods -n default -l volcano.sh/job-name=spark-pi-simple 2>/dev/null || echo "No Spark jobs running"
echo ""
echo "====================================="
echo "UI Access"
echo "====================================="
echo ""
echo "Volcano UI:"
echo "  Note: Volcano does not have a web UI"
echo "  Use: kubectl get queue, kubectl get vcjob"
echo ""
echo "Flink UI:"
echo "  Direct access: http://localhost:30080"
echo "  Or port-forward: kubectl port-forward -n flink svc/flink-jobmanager 8081:8081"
echo "  Then visit: http://localhost:8081"
echo ""
echo "Spark UI (when job is running):"
echo "  Get Spark driver pod:"
SPARK_POD=$(kubectl get pods -n default -l volcano.sh/job-name=spark-pi-simple -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "$SPARK_POD" ]; then
  echo "  Port-forward: kubectl port-forward -n default $SPARK_POD 4040:4040"
  echo "  Then visit: http://localhost:4040"
else
  echo "  No Spark job running. Start with: ./job/submit-spark.sh"
fi
echo ""
echo "====================================="
