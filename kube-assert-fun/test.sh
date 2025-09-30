#!/bin/bash

set -e

echo "Running kubectl-assert tests"

echo "Test 1: Assert nginx deployment exists"
kubectl assert exist deployment nginx-deployment

echo "Test 2: Assert nginx deployment exists in default namespace"
kubectl assert exist deployment nginx-deployment -n default

echo "Test 3: Assert nginx service exists"
kubectl assert exist service nginx-service

echo "Test 4: Assert nginx pods exist with label app=nginx"
kubectl assert exist pods -l app=nginx

echo "Test 5: Assert nginx pods are running"
kubectl assert exist pods -l app=nginx --field-selector status.phase=Running

echo "Test 6: Assert all resources with app=nginx label exist"
kubectl assert exist deployment,service,pods -l app=nginx

echo "All tests passed successfully!"