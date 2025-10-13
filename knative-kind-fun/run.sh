#!/bin/bash
set -e

echo "Creating KIND cluster..."
kind create cluster --name knative --config kind-config.yaml

echo "Installing Knative Serving CRDs..."
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.15.0/serving-crds.yaml

echo "Installing Knative Serving Core..."
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.15.0/serving-core.yaml

echo "Waiting for Knative Serving to be ready..."
max_wait=300
elapsed=0
while [ $elapsed -lt $max_wait ]; do
  pod_count=$(kubectl get pods -n knative-serving --no-headers 2>/dev/null | wc -l || echo "0")
  if [ "$pod_count" -gt 0 ]; then
    if kubectl wait --for=condition=ready pod --all -n knative-serving --timeout=1s >/dev/null 2>&1; then
      echo "Knative Serving is ready!"
      break
    fi
  fi
  elapsed=$((elapsed + 1))
  sleep 1
done

echo "Installing Kourier networking layer..."
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.15.0/kourier.yaml

echo "Waiting for Kourier to be ready..."
max_wait=300
elapsed=0
while [ $elapsed -lt $max_wait ]; do
  pod_count=$(kubectl get pods -n kourier-system --no-headers 2>/dev/null | wc -l || echo "0")
  if [ "$pod_count" -gt 0 ]; then
    if kubectl wait --for=condition=ready pod --all -n kourier-system --timeout=1s >/dev/null 2>&1; then
      echo "Kourier is ready!"
      break
    fi
  fi
  elapsed=$((elapsed + 1))
  sleep 1
done

echo "Configuring Knative Serving to use Kourier..."
kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

echo "Configuring DNS..."
kubectl patch configmap/config-domain \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"127.0.0.1.sslip.io":""}}'

echo "Deploying Knative services from specs/..."
kubectl apply -f specs/

echo "Waiting for services to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
  ready=$(kubectl get ksvc -n default -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "")
  if [ "$ready" = "True" ]; then
    echo "Services are ready!"
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ $attempt -eq $max_attempts ]; then
  echo "Warning: Services did not become ready in time"
fi

echo "Installing Kubernetes Dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo "Creating dashboard admin user..."
kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard 2>/dev/null || true
kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin 2>/dev/null || true

echo "Waiting for dashboard to be ready..."
max_wait=60
elapsed=0
while [ $elapsed -lt $max_wait ]; do
  pod_count=$(kubectl get pods -n kubernetes-dashboard --no-headers 2>/dev/null | wc -l || echo "0")
  if [ "$pod_count" -gt 0 ]; then
    if kubectl wait --for=condition=ready pod --all -n kubernetes-dashboard --timeout=1s >/dev/null 2>&1; then
      echo "Dashboard is ready!"
      break
    fi
  fi
  elapsed=$((elapsed + 1))
  sleep 1
done

echo "KIND cluster with Knative is ready!"
echo "Use kubectl get ksvc to see your services"
echo "Use ./ui.sh to access the Kubernetes Dashboard"
