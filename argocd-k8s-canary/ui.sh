#!/bin/bash
set -e
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)

echo "==============================================="
echo " argocd:  https://localhost:8080"
echo " user:    admin"
echo " pass:    $PASS"
echo "==============================================="
echo "press Ctrl-C to stop port-forward"
kubectl -n argocd port-forward svc/argocd-server 8080:443
