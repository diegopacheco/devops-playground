#!/bin/bash
set -e
export KIND_EXPERIMENTAL_PROVIDER=podman
kind delete cluster --name argocd-canary
