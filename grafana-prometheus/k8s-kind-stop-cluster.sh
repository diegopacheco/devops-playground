#!/bin/bash

docker ps

docker stop $(docker ps -q --filter "name=grafana")

docker ps
