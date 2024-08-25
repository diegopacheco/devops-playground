#!/bin/bash

kubectl cluster-info --context kind-grafana
kind load docker-image sb3-netty:latest --name grafana

kubectl apply -f specs/sb3-netty-deployment.yaml --force
kubectl apply -f specs/sb3-netty-service.yaml --force

kubectl apply -f specs/grafana-deployment.yaml --force
kubectl apply -f specs/grafana-service.yaml --force

kubectl apply -f specs/node-exporter-daemonset.yaml --force
kubectl apply -f specs/node-exporter-service.yaml --force
kubectl apply -f specs/cadvisor-daemonset.yaml --force

kubectl apply -f specs/prometheus-deployment.yaml --force
kubectl apply -f specs/prometheus-service.yaml --force
kubectl apply -f specs/prometheus-sb-configmap.yaml --force
kubectl apply -f specs/prometheus-ne-configmap.yaml --force
