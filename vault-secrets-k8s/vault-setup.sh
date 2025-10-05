#!/bin/bash

helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

helm install vault hashicorp/vault \
  --set "server.dev.enabled=true" \
  --set "server.dev.devRootToken=root" \
  --set "injector.enabled=true" \
  --set "server.service.type=NodePort" \
  --set "server.service.nodePort=30200"

echo "Waiting for Vault pod to be ready..."
for i in {1..60}; do
  if kubectl get pod vault-0 -o jsonpath='{.status.phase}' 2>/dev/null | grep -q Running; then
    echo "Vault pod is running"
    break
  fi
  sleep 1
done

kubectl wait --for=condition=ready pod/vault-0 --timeout=120s

kubectl exec vault-0 -- vault auth enable kubernetes

kubectl exec vault-0 -- vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc:443"

kubectl exec vault-0 -- vault kv put secret/myapp/config \
  username="admin" \
  password="super-secret-password" \
  api_key="abc123xyz789"

kubectl exec vault-0 -- sh -c 'vault policy write myapp-policy - <<EOF
path "secret/data/myapp/config" {
  capabilities = ["read"]
}
EOF'

kubectl exec vault-0 -- vault write auth/kubernetes/role/myapp \
  bound_service_account_names=myapp-sa \
  bound_service_account_namespaces=default \
  policies=myapp-policy \
  audience="https://kubernetes.default.svc.cluster.local" \
  ttl=24h
