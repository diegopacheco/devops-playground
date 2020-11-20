#!/bin/bash

kubectl port-forward service/k8ssandra-dc1-all-pods-service 9049:9042 
