#!/bin/bash

echo "Testing Docker inside Docker..."
podman exec dind-poc docker run --rm hello-world
echo "Docker inside Docker is working!"
