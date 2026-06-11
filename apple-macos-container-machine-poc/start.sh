#!/usr/bin/env bash
set -euo pipefail

REDIS_IMAGE="docker.io/library/redis:8"
CONTAINER_NAME="redis8"
HOST_IP="127.0.0.1"
HOST_PORT="16379"
CONTAINER_PORT="6379"

if [ "$(uname -m)" != "arm64" ]; then
  echo "Apple container requires an Apple silicon (arm64) Mac."
  exit 1
fi

if ! command -v container >/dev/null 2>&1; then
  echo "container CLI not found. Installing via Homebrew..."
  brew install container
fi

echo "container version:"
container --version

echo "Starting the container system service (the container machine host)..."
container system start --enable-kernel-install

echo "Pulling Redis 8 image: ${REDIS_IMAGE}"
container image pull "${REDIS_IMAGE}"

if container inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
  echo "Found a previous ${CONTAINER_NAME}, removing it..."
  container stop "${CONTAINER_NAME}" >/dev/null 2>&1 || true
  container rm "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

echo "Running Redis 8 inside its own container machine..."
container run -d --name "${CONTAINER_NAME}" \
  --publish "${HOST_IP}:${HOST_PORT}:${CONTAINER_PORT}" \
  "${REDIS_IMAGE}"

echo "Waiting for Redis to accept connections on ${HOST_IP}:${HOST_PORT}..."
ATTEMPTS=0
until redis-cli -h "${HOST_IP}" -p "${HOST_PORT}" ping 2>/dev/null | grep -q "PONG"; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "${ATTEMPTS}" -ge 60 ]; then
    echo "Redis did not become ready in time. Container logs:"
    container logs "${CONTAINER_NAME}" || true
    exit 1
  fi
  sleep 1
done

echo "Redis 8 is up and reachable on ${HOST_IP}:${HOST_PORT}"
echo
container ls
