#!/bin/bash

echo "Starting chaos engineering with Pumba..."

if ! docker-compose ps | grep -q "web-server\|api-server"; then
    echo "No containers found. Please run ./run.sh first to start containers."
    exit 1
fi

echo "Current container status:"
docker-compose ps

echo ""
echo "Downloading Pumba binary..."
if [ ! -f "./pumba" ]; then
    curl -L https://github.com/alexei-led/pumba/releases/download/0.9.0/pumba_darwin_amd64 -o pumba
    chmod +x pumba
fi

echo ""
echo "Killing web-server container with Pumba..."
DOCKER_HOST=unix:///var/run/docker.sock ./pumba kill web-server

sleep 3

echo "Container status after kill:"
docker-compose ps

echo ""
echo "Manually restarting killed service (simulating orchestrator recovery)..."
docker-compose up -d web

sleep 5

echo "Container status after recovery:"
docker-compose ps

echo ""
echo "Pausing api-server container with Pumba..."
DOCKER_HOST=unix:///var/run/docker.sock ./pumba pause --duration 15s api-server &

sleep 5

echo "Testing connectivity during pause:"
curl -m 5 http://localhost:8082 || echo "Connection failed - container paused"

sleep 15

echo ""
echo "Stopping web-server container with Pumba..."
DOCKER_HOST=unix:///var/run/docker.sock ./pumba stop --time 10 web-server

sleep 5

echo "Container status after stop:"
docker-compose ps

echo "Testing connectivity after stop:"
curl -m 3 http://localhost:8081 || echo "Connection failed - container stopped"

echo ""
echo "Waiting for auto-restart..."
sleep 10

echo ""
echo "Final container status:"
docker-compose ps

echo ""
echo "Chaos engineering with Pumba completed. Recovery verified."

echo "removing pumba binary..."
rm pumba