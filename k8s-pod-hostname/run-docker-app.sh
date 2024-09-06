#!/bin/bash

# Define the image name
IMAGE_NAME="python-app-hostname:latest"

# Run the Docker container
docker run --rm -p 8080:80 -e HOSTNAME=$(hostname) -e POD_NAME="pod-$(hostname)" -e POD_NAMESPACE="default" $IMAGE_NAME