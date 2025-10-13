#!/bin/bash
set -e

echo "Starting Kubernetes Dashboard..."
echo ""

echo "Getting authentication token..."
TOKEN=$(kubectl create token dashboard-admin -n kubernetes-dashboard --duration=24h)

echo ""
echo "============================================"
echo "Kubernetes Dashboard Access"
echo "============================================"
echo ""
echo "Dashboard URL: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo ""
echo "Authentication Token (copy this):"
echo ""
echo "$TOKEN"
echo ""
echo "============================================"
echo ""
echo "Instructions:"
echo "1. Dashboard will open on localhost:8001"
echo "2. Select 'Token' authentication method"
echo "3. Paste the token above"
echo "4. Navigate to: Knative > Services to see your functions"
echo ""
echo "Press Ctrl+C to stop the dashboard"
echo ""

kubectl proxy
