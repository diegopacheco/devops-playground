#!/bin/bash
set -e

echo "========================================="
echo "Testing Polaris Validation"
echo "========================================="

echo ""
echo "Checking if cluster is running..."
if ! kind get clusters | grep -q "polaris-validation"; then
  echo "Cluster not found. Run ./run.sh first"
  exit 1
fi

echo ""
echo "Checking Polaris deployment..."
kubectl get deployment -n polaris polaris-dashboard

echo ""
echo "Checking test deployments..."
kubectl get deployments

echo ""
echo "Installing Polaris CLI..."
if [ "$(uname)" == "Darwin" ]; then
  if ! command -v polaris &> /dev/null; then
    curl -L https://github.com/FairwindsOps/polaris/releases/latest/download/polaris_darwin_amd64.tar.gz | tar xz
    chmod +x polaris
    export PATH="$PWD:$PATH"
  fi
fi

echo ""
echo "Running Polaris audit on bad-deployment..."
kubectl get deployment bad-app -o yaml | ./polaris audit --format=pretty --audit-path=- || true

echo ""
echo "Running Polaris audit on good-deployment..."
kubectl get deployment good-app -o yaml | ./polaris audit --format=pretty --audit-path=- || true

echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo ""
echo "Bad deployment should show multiple validation failures:"
echo "  - Missing resource requests/limits"
echo "  - Missing liveness/readiness probes"
echo "  - Running as root"
echo "  - Using latest tag"
echo ""
echo "Good deployment should show passing validation or minimal warnings"
echo ""
echo "You can also access the Polaris dashboard with:"
echo "  kubectl port-forward -n polaris svc/polaris-dashboard 8080:80"
echo "  Then open http://localhost:8080"
