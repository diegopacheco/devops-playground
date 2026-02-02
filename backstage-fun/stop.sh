#!/bin/bash

echo "Stopping Backstage container..."
podman ps -q --filter "ancestor=roadiehq/community-backstage-image" | xargs -r podman stop 2>/dev/null
podman ps -q --filter "publish=3000" | xargs -r podman stop 2>/dev/null

echo "Stopping Kind cluster..."
kind delete cluster --name backstage-cluster

echo "Done."
