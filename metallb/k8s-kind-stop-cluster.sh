#!/bin/bash

docker ps

docker stop $(docker ps -q --filter "name=cluster-mlb")

docker ps