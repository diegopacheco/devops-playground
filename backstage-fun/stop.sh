#!/bin/bash

echo "Stopping kubectl proxy..."
pkill -f "kubectl proxy" 2>/dev/null

echo "Deleting Kind cluster..."
kind delete cluster --name backstage-cluster

echo "Done."
