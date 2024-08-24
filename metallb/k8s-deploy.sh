#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml --force

kubectl apply -f specs/metallb-config.yaml --force

kubectl apply -f specs/echo-deployment.yaml --force
kubectl apply -f specs/echo-service.yaml --force

kubectl rollout restart deployment -n metallb-system