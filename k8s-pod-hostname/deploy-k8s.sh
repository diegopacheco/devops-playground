#!/bin/bash

kubectl cluster-info --context kind-kind

kind load docker-image python-app-hostname:latest
kubectl apply -f specs/deployment.yaml --force
kubectl apply -f specs/service.yaml --force