#!/bin/bash

docker ps

docker stop $(docker ps -q --filter "name=kind-grafana")

docker ps