#!/bin/bash

echo "Destroying Kind cluster..."

kind delete cluster --name cdk8s-cluster
echo "Kind cluster destroyed successfully!"
