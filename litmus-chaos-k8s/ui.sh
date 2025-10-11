#!/bin/bash
set -e

echo "Checking for Litmus services in namespace litmus"
kubectl get svc -n litmus

echo ""
echo "Port-forwarding Litmus UI to localhost:9091"
echo "Default credentials - Username: admin | Password: litmus"
echo "Opening browser at http://localhost:9091"

open http://localhost:9091 &

kubectl port-forward -n litmus svc/litmusportal-frontend-service 9091:9091
