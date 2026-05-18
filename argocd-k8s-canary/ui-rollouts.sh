#!/bin/bash
set -e
echo "==============================================="
echo " argo rollouts dashboard: http://localhost:3100/rollouts"
echo "==============================================="
echo "press Ctrl-C to stop port-forward"
kubectl -n argo-rollouts port-forward svc/argo-rollouts-dashboard 3100:3100
