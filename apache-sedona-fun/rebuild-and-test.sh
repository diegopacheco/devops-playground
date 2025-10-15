#!/bin/bash
set -e

echo "=== Rebuilding Flink-Sedona Application ==="

echo "Step 1: Building Maven project..."
cd flink-sedona-app
mvn clean package -DskipTests -q
cd ..

echo "Step 2: Updating ConfigMap with performance optimizations..."
kubectl apply -f specs/configmap.yaml

echo "Step 3: Building Docker image with new JAR..."
podman build -t flink-sedona:latest . -q

echo "Step 3: Building Docker image with new JAR..."
podman build -t flink-sedona:latest . -q

echo "Step 4: Saving and loading image into kind cluster..."
podman save -o /tmp/flink-sedona.tar localhost/flink-sedona:latest
kind load image-archive /tmp/flink-sedona.tar --name flink-sedona-cluster
rm -f /tmp/flink-sedona.tar

echo "Step 5: Restarting Flink cluster with optimized config..."
kubectl delete -f specs/jobmanager.yaml
kubectl delete -f specs/taskmanager.yaml
sleep 3
kubectl apply -f specs/jobmanager.yaml
kubectl apply -f specs/taskmanager.yaml

echo "Step 6: Waiting for cluster to be ready..."
kubectl wait --for=condition=ready pod -l component=jobmanager -n flink-sedona --timeout=60s
kubectl wait --for=condition=ready pod -l component=taskmanager -n flink-sedona --timeout=60s

echo "Step 7: Submitting optimized Sedona job..."
sleep 3
JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')

echo "Starting timer..."
START_TIME=$(date +%s)
kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "=== Job completed in ${ELAPSED} seconds! ==="
echo "Target: under 20 seconds"
echo "View JobManager UI: http://localhost:30081"
echo "Check detailed logs: kubectl logs -n flink-sedona $JOBMANAGER_POD --tail=100"
