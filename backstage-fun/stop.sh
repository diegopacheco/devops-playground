#!/bin/bash

echo "Stopping Kind cluster..."
kind delete cluster --name backstage-cluster

echo "Done."
