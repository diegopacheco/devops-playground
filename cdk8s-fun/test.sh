#!/bin/bash

echo "=========================================="
echo "CDK8s Nginx Deployment Test"
echo "=========================================="

echo ""
echo "1. Installing npm dependencies..."
npm install

echo ""
echo "2. Generating Kubernetes manifests with CDK8s..."
node main.js

echo ""
echo "3. Generated manifests:"
echo "---"
cat dist/nginx.k8s.yaml
echo "---"

echo ""
echo "4. Deploying to Kubernetes cluster..."
kubectl apply -f dist/

echo ""
echo "5. Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/nginx-deployment-c8b367ce

echo ""
echo "6. Deployment Status:"
kubectl get deployments

echo ""
echo "7. Deployed Pods:"
kubectl get pods -o wide

echo ""
echo "8. Services:"
kubectl get services

echo ""
echo "9. Pod Details:"
kubectl describe pods -l app=nginx-deployment-c8b367ce

echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo ""
echo "You can access nginx at: http://localhost:8080"
echo ""
echo "To check logs: kubectl logs -l app=nginx-deployment-c8b367ce"
echo "To delete: kubectl delete -f dist/"
