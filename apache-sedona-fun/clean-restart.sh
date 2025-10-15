#!/bin/bash
set -e

echo "=== Clean Restart & Fast Test ==="

echo "1. Building JAR..."
cd flink-sedona-app
mvn clean package -DskipTests -q
cd ..

echo "2. Building Docker image..."
podman build -t flink-sedona:latest . -q

echo "3. Loading into kind..."
podman save -o /tmp/flink-sedona.tar localhost/flink-sedona:latest
kind load image-archive /tmp/flink-sedona.tar --name flink-sedona-cluster
rm -f /tmp/flink-sedona.tar

echo "4. Deleting ALL Flink pods..."
kubectl delete pods -n flink-sedona --all --wait=true

echo "5. Waiting for pods to restart..."
sleep 5
kubectl wait --for=condition=ready pod -l component=jobmanager -n flink-sedona --timeout=120s
kubectl wait --for=condition=ready pod -l component=taskmanager -n flink-sedona --timeout=120s

echo "6. Checking cluster status..."
kubectl get pods -n flink-sedona

echo "7. Waiting for cluster to stabilize..."
sleep 10

echo "8. Submitting job..."
JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')

echo ""
echo "======================================"
START_TIME=$(date +%s)
kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "======================================"
echo "✅ Completed in ${ELAPSED} seconds!"
echo "======================================"
