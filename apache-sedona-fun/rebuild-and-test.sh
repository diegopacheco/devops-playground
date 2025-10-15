#!/bin/bash
set -e

echo "=== Rebuilding Flink-Sedona Application ==="

echo "Step 1: Building Maven project..."
cd flink-sedona-app
mvn clean package -DskipTests
cd ..

echo "Step 2: Building Docker image with new JAR..."
podman build -t flink-sedona:latest .

echo "Step 3: Saving and loading image into kind cluster..."
podman save -o /tmp/flink-sedona.tar localhost/flink-sedona:latest
kind load image-archive /tmp/flink-sedona.tar --name flink-sedona-cluster
rm -f /tmp/flink-sedona.tar

echo "Step 4: Restarting JobManager to pick up new JAR..."
kubectl delete -f specs/jobmanager.yaml
sleep 2
kubectl apply -f specs/jobmanager.yaml

echo "Step 5: Waiting for JobManager to be ready..."
kubectl wait --for=condition=ready pod -l component=jobmanager -n flink-sedona --timeout=60s

echo "Step 6: Submitting simplified Sedona job..."
sleep 5  
JOBMANAGER_POD=$(kubectl get pods -n flink-sedona -l component=jobmanager -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n flink-sedona $JOBMANAGER_POD -c jobmanager -- ./bin/flink run /opt/flink/usrlib/flink-sedona-app-1.0.jar

echo ""
echo "=== Job submitted! ==="
echo "The simplified query should complete in under 30 seconds."
echo "View JobManager UI: http://localhost:30081"
echo "Check logs: kubectl logs -n flink-sedona $JOBMANAGER_POD --tail=100"
