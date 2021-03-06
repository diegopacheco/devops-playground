#!/bin/bash

#
# Minukube setup
#
minikube start --memory=8192 --cpus=8 -p k8ssandra 

#
# k8ssandra
#

helm repo add k8ssandra https://helm.k8ssandra.io/
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install k8ssandra-tools k8ssandra/k8ssandra
helm install k8ssandra-cluster-a k8ssandra/k8ssandra-cluster

#
# Traefik
#

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik.values.yaml

minikube service traefik -n traefik --url -p k8ssandra
xdg-open "http://192.168.99.121:32090/dashboard/#/"

#
# Grafana
#

helm upgrade k8ssandra-cluster-a k8ssandra/k8ssandra-cluster --set ingress.traefik.enabled=true --set ingress.traefik.monitoring.grafana.host=grafana.localhost --set ingress.traefik.monitoring.prometheus.host=prometheus.localhost


