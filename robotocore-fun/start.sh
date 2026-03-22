#!/bin/bash
podman-compose up -d
echo "Waiting for robotocore to be ready..."
while ! curl -s http://localhost:4566/_robotocore/health > /dev/null 2>&1; do
  sleep 1
done
echo "robotocore is ready!"
