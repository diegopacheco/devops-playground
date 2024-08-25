#!/bin/bash

PROMETHEUS_POD=$(kubectl get pods -l app=prometheus -o jsonpath="{.items[0].metadata.name}")
kubectl exec -it $PROMETHEUS_POD -- cat /etc/prometheus/prometheus.yml