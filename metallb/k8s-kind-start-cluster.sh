#!/bin/bash

docker ps

docker start $(docker ps -a -q --filter "name=cluster-mlb")

docker ps

sleep 6

kubectl get all% 