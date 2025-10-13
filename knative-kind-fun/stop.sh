#!/bin/bash
set -e

echo "Deleting KIND cluster..."
kind delete cluster --name knative

echo "KIND cluster deleted successfully!"
