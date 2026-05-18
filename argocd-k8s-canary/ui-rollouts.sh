#!/bin/bash
set -e
echo "==============================================="
echo " argo rollouts dashboard:"
echo "   http://localhost:3100/rollouts/canary-app"
echo " (the /canary-app suffix selects the namespace;"
echo "  /rollouts alone loads the dashboard's own ns which is empty)"
echo "==============================================="
echo "press Ctrl-C to stop port-forward"
kubectl -n argo-rollouts port-forward svc/argo-rollouts-dashboard 3100:3100
