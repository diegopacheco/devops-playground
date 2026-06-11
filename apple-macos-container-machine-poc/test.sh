#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="redis8"
HOST_IP="127.0.0.1"
HOST_PORT="16379"

echo "Container machines currently running:"
container ls

echo
echo "redis-cli version on host:"
redis-cli --version

echo
echo "PING ->"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" ping

echo
echo "Redis server version running inside the container machine:"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" info server | grep -i "redis_version"

echo
echo "SET poc:key ->"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" set poc:key "apple-container-redis8"

echo "GET poc:key ->"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" get poc:key

echo
echo "INCR poc:counter twice ->"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" incr poc:counter
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" incr poc:counter

echo "GET poc:counter ->"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" get poc:counter

echo
echo "Keys stored:"
redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" keys "poc:*"
