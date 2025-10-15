#!/bin/bash
set -e

echo "=== Ultra-Fast Rebuild & Test ==="

echo "1. Building JAR (quiet mode)..."
cd flink-sedona-app
mvn clean package -DskipTests -q > /dev/null 2>&1
cd ..

echo "2. Building Docker image..."
podman build -t flink-sedona:latest . -q 2>/dev/null

echo "3. Loading into kind..."
podman save -o /tmp/flink-sedona.tar localhost/flink-sedona:latest
kind load image-archive /tmp/flink-sedona.tar --name flink-sedona-cluster 2>/dev/null
rm -f /tmp/flink-sedona.tar

echo "4. Restarting Flink cluster..."
kubectl delete pod -n flink-sedona -l component=jobmanager 2>/dev/null
kubectl delete pod -n flink-sedona -l component=taskmanager 2>/dev/null
echo "Waiting for pods to restart..."
kubectl wait --for=condition=ready pod -l component=jobmanager -n flink-sedona --timeout=60s 2>/dev/null
kubectl wait --for=condition=ready pod -l component=taskmanager -n flink-sedona --timeout=60s 2>/dev/null

echo "5. Submitting ultra-simple job..."
sleep 3
JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')

echo ""
echo "======================================"
START_TIME=$(date +%s)
kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "======================================"
echo "✅ Job completed in ${ELAPSED} seconds!"
echo "======================================"

if [ $ELAPSED -le 20 ]; then
    echo "🎉 SUCCESS! Under 20 seconds!"
else
    echo "⚠️  Took ${ELAPSED}s (target: 20s)"
fi
