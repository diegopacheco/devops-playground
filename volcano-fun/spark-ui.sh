#!/bin/bash

SPARK_POD=$(kubectl get pods -n default -l volcano.sh/job-name=spark-long-running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$SPARK_POD" ]; then
  SPARK_POD=$(kubectl get pods -n default -l volcano.sh/job-name=spark-pi-simple -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
fi

if [ -z "$SPARK_POD" ]; then
  echo "No Spark job found"
  echo ""
  echo "Start a Spark job:"
  echo "  Quick job (1 min):  ./job/submit-spark.sh"
  echo "  Long job (5+ min):  ./job/submit-spark-long.sh"
  exit 1
fi

POD_STATUS=$(kubectl get pod -n default $SPARK_POD -o jsonpath='{.status.phase}' 2>/dev/null)

if [ "$POD_STATUS" != "Running" ]; then
  echo "Spark job pod found: $SPARK_POD"
  echo "Pod status: $POD_STATUS"
  echo ""
  echo "Spark UI is only available when the pod is running."
  echo ""
  echo "For reliable UI access, use the long-running job:"
  echo "  ./job/submit-spark-long.sh"
  echo "  Wait 10-15 seconds, then run: ./spark-ui.sh"
  exit 1
fi

echo "Spark job pod found: $SPARK_POD"
echo "Pod status: $POD_STATUS"
echo "Starting port-forward to Spark UI..."
echo "Access Spark UI at: http://localhost:4040"
echo ""
kubectl port-forward -n default $SPARK_POD 4040:4040
