#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="redis8"

if container inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
  echo "Stopping ${CONTAINER_NAME}..."
  container stop "${CONTAINER_NAME}" || true
  echo "Removing ${CONTAINER_NAME}..."
  container rm "${CONTAINER_NAME}" || true
else
  echo "No ${CONTAINER_NAME} container found."
fi

echo
echo "Remaining containers:"
container ls --all

echo
echo "The container machine service is still running."
echo "To stop the whole service run: container system stop"
