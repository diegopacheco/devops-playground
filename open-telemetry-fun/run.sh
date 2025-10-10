#!/bin/bash
set -e
echo "Creating kind cluster..."
kind create cluster --name otel-cluster
echo "Building Docker image..."
podman build -t otel-app:latest .
podman tag localhost/otel-app:latest otel-app:latest
echo "Loading image into kind..."
podman save localhost/otel-app:latest -o /tmp/otel-app.tar
kind load image-archive /tmp/otel-app.tar --name otel-cluster
rm /tmp/otel-app.tar
echo "Deploying Jaeger..."
kubectl apply -f specs/jaeger.yaml
echo "Deploying Prometheus..."
kubectl apply -f specs/prometheus.yaml
echo "Deploying Grafana..."
kubectl apply -f specs/grafana.yaml
echo "Deploying OpenTelemetry Collector..."
kubectl apply -f specs/otel-collector.yaml
echo "Deploying application..."
kubectl apply -f specs/app-deployment.yaml
echo "Waiting for all pods to be ready..."
TIMEOUT=300
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  TOTAL=$(kubectl get pods --no-headers 2>/dev/null | grep -v Completed | wc -l | tr -d ' ' | tr -d '\n')
  RUNNING=$(kubectl get pods --no-headers 2>/dev/null | grep Running | awk '{if ($2 == "1/1" || $2 == "2/2") print $1}' | wc -l | tr -d ' ' | tr -d '\n')
  if [ "$TOTAL" -gt 0 ] && [ "$RUNNING" -eq "$TOTAL" ]; then
    echo "All pods are ready!"
    kubectl get pods
    break
  fi
  echo "Waiting for pods... ($RUNNING/$TOTAL ready)"
  sleep 1
  ELAPSED=$((ELAPSED + 1))
done
if [ $ELAPSED -ge $TIMEOUT ]; then
  echo "Timeout waiting for pods to be ready"
  kubectl get pods
  exit 1
fi
echo "Deployment completed successfully!"
echo "Access services:"
echo "  Grafana: kubectl port-forward svc/grafana 3000:3000"
echo "  Jaeger: kubectl port-forward svc/jaeger 16686:16686"
echo "  Prometheus: kubectl port-forward svc/prometheus 9090:9090"
echo "  Application: kubectl port-forward svc/otel-app 8080:8080"
