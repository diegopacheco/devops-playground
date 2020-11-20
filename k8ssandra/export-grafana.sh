#!/bin/bash

# user admin pass secret
kubectl port-forward service/grafana-service 3000:3000 
