#!/bin/bash
set -e

PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)

echo "==============================================="
echo " argocd:  https://localhost:8080"
echo " user:    admin"
echo " pass:    $PASS"
echo "==============================================="
echo ""

kubectl -n argocd port-forward svc/argocd-server 8080:443 >/tmp/argocd-pf.log 2>&1 &
PF1=$!

PF2=""
if kubectl argo rollouts version >/dev/null 2>&1; then
  echo " argo rollouts dashboard: http://localhost:3100/rollouts"
  echo "==============================================="
  kubectl argo rollouts dashboard -p 3100 >/tmp/rollouts-pf.log 2>&1 &
  PF2=$!
else
  echo " (kubectl argo rollouts plugin not installed - skipping dashboard)"
  echo " install: https://argoproj.github.io/argo-rollouts/installation/#kubectl-plugin-installation"
  echo "==============================================="
fi

trap "kill $PF1 $PF2 2>/dev/null; exit 0" INT TERM
echo "press Ctrl-C to stop port-forwards"
wait
