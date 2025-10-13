#!/bin/bash
set -e

echo "Getting service URL..."
SERVICE_URL=$(kubectl get ksvc hello -o jsonpath='{.status.url}')
SERVICE_HOST=$(echo $SERVICE_URL | sed 's|http://||' | sed 's|https://||')

echo "Service URL: $SERVICE_URL"
echo "Service Host: $SERVICE_HOST"
echo ""
echo "Calling the function from inside the cluster..."
echo ""

kubectl run curl --image=curlimages/curl:latest --rm -it --restart=Never -- curl -s -H "Host: $SERVICE_HOST" http://kourier.kourier-system.svc.cluster.local

echo ""
echo ""
echo "Function call completed!"
