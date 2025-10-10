#!/bin/bash
set -e
echo "Starting port-forwarding for observability UIs..."
kubectl port-forward svc/grafana 3000:3000 &
PID_GRAFANA=$!
kubectl port-forward svc/jaeger 16686:16686 &
PID_JAEGER=$!
kubectl port-forward svc/prometheus 9090:9090 &
PID_PROMETHEUS=$!
kubectl port-forward svc/otel-app 8080:8080 &
PID_APP=$!
echo "Waiting for port-forwards to be ready..."
sleep 1
TIMEOUT=30
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  if nc -z localhost 3000 2>/dev/null && nc -z localhost 16686 2>/dev/null && nc -z localhost 9090 2>/dev/null && nc -z localhost 8080 2>/dev/null; then
    echo "All port-forwards are ready!"
    break
  fi
  sleep 1
  ELAPSED=$((ELAPSED + 1))
done
echo ""
echo "Observability UIs are available at:"
echo "  Grafana:    http://localhost:3000 (admin/admin)"
echo "  Jaeger:     http://localhost:16686"
echo "  Prometheus: http://localhost:9090"
echo "  App:        http://localhost:8080"
echo ""
echo "Opening UIs in browser..."
open http://localhost:3000 2>/dev/null || echo "  Open http://localhost:3000 manually"
open http://localhost:16686 2>/dev/null || echo "  Open http://localhost:16686 manually"
open http://localhost:9090 2>/dev/null || echo "  Open http://localhost:9090 manually"
echo ""
echo "Generating traffic to application..."
for i in {1..10}; do
  curl -s http://localhost:8080/ > /dev/null
  curl -s http://localhost:8080/api/data > /dev/null
  sleep 1
done
echo "Traffic generated. Check the UIs for traces and metrics!"
echo ""
echo "Press Ctrl+C to stop port-forwarding..."
trap "kill $PID_GRAFANA $PID_JAEGER $PID_PROMETHEUS $PID_APP 2>/dev/null; exit 0" INT TERM
wait
