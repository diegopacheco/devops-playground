#!/bin/bash
set -e

echo "Checking if kubeconform is installed..."
if ! command -v kubeconform &> /dev/null; then
    echo "kubeconform not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install kubeconform
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -L https://github.com/yannh/kubeconform/releases/latest/download/kubeconform-linux-amd64.tar.gz | tar xz
        sudo mv kubeconform /usr/local/bin/
    fi
fi

echo "Validating Kubernetes manifests with kubeconform..."
kubeconform -summary -output json specs/deployment.yaml specs/service.yaml

echo "Validation complete!"