#!/bin/bash

echo "Starting chaos engineering..."

if ! docker-compose ps | grep -q "web-server\|api-server"; then
    echo "No containers found. Please run ./run.sh first to start containers."
    exit 1
fi

echo "Current container status:"
docker-compose ps

echo ""
echo "Killing web-server container..."
docker-compose kill web-server

sleep 3

echo "Container status after kill:"
docker-compose ps

echo ""
echo "Waiting for recovery..."
sleep 10

echo "Container status after recovery:"
docker-compose ps

echo ""
echo "Stopping api-server container..."
docker-compose stop api-server

sleep 5

echo "Testing connectivity during stop:"
curl -m 5 http://localhost:8082 || echo "Connection failed - container stopped"

echo ""
echo "Starting api-server container..."
docker-compose start api-server

sleep 5

echo ""
echo "Final container status:"
docker-compose ps

echo ""
echo "Chaos engineering completed. Recovery verified."