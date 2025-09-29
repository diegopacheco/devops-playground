#!/bin/bash

if ! podman info > /dev/null 2>&1; then
    echo "Podman is not running. Please start Podman machine first."
    exit 1
fi

docker-compose up -d

echo "Containers starting..."
sleep 5

echo "Container status:"
docker-compose ps

echo "Web server available at: http://localhost:8081"
echo "API server available at: http://localhost:8082"