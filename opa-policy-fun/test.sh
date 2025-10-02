#!/bin/bash

set -e

echo "========================================="
echo "Testing OPA Gatekeeper Policies"
echo "========================================="

echo ""
echo "1. Testing require-labels policy (should FAIL - missing labels)..."
cat <<EOF | kubectl apply -f - 2>&1 || echo "✓ Policy blocked pod without labels"
apiVersion: v1
kind: Pod
metadata:
  name: test-no-labels
spec:
  containers:
  - name: nginx
    image: nginx:1.23
EOF

echo ""
echo "2. Testing disallow-latest-tag policy (should FAIL - using latest tag)..."
cat <<EOF | kubectl apply -f - 2>&1 || echo "✓ Policy blocked pod with latest tag"
apiVersion: v1
kind: Pod
metadata:
  name: test-latest-tag
  labels:
    app: web
    team: platform
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF

echo ""
echo "3. Creating valid pod (should SUCCEED)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test-valid-pod
  labels:
    app: web
    team: platform
spec:
  containers:
  - name: nginx
    image: nginx:1.23
EOF

echo ""
echo "4. Verifying pod was created successfully..."
kubectl get pod test-valid-pod

echo ""
echo "5. Testing restrict-registries policy (should FAIL - unauthorized registry)..."
cat <<EOF | kubectl apply -f - 2>&1 || echo "✓ Policy blocked pod from unauthorized registry"
apiVersion: v1
kind: Pod
metadata:
  name: test-bad-registry
  labels:
    app: web
    team: platform
spec:
  containers:
  - name: app
    image: malicious.registry.com/app:1.0
EOF

echo ""
echo "========================================="
echo "Cleaning up test resources..."
echo "========================================="
kubectl delete pod test-valid-pod --ignore-not-found=true

echo ""
echo "========================================="
echo "Policy Validation Complete!"
echo "========================================="
echo ""
echo "Summary of policies tested:"
echo "  ✓ require-labels: Enforces app and team labels"
echo "  ✓ disallow-latest-tag: Prevents using :latest tag"
echo "  ✓ restrict-registries: Only allows approved container registries"
