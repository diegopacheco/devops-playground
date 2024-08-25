#!/bin/bash

kind load docker-image sb3-netty:latest

kubectl apply -f specs/sb3-netty-deployment.yaml --force
kubectl apply -f specs/sb3-netty-service.yaml --force

kubectl apply -f specs/grafana-deployment.yaml --force
kubectl apply -f specs/grafana-service.yaml --force

kubectl apply -f specs/prometheus-deployment.yaml --force
kubectl apply -f specs/prometheus-service.yaml --force
kubectl apply -f specs/prometheus-sb-configmap.yaml --force