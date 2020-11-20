#!/bin/bash

# goto http://localhost:8080/webui/ 
kubectl port-forward service/k8ssandra-cluster-a-reaper-k8ssandra-reaper-service 8080:8080 
