#!/bin/bash

# Define the image name
IMAGE_NAME="python-app-hostname"

# Build the Docker image
docker build -t $IMAGE_NAME . --no-cache