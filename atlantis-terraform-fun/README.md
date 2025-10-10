# Atlantis Terraform on Kubernetes

This project sets up a local Kubernetes cluster using kind with Atlantis to manage Terraform deployments.

## Results

```
```

## Prerequisites

- Podman
- kind
- kubectl
- terraform

## Quick Start

### Start the cluster

```bash
./run.sh
```

This will:
- Create a kind cluster named "atlantis-cluster"
- Deploy Atlantis to the cluster
- Set up all necessary resources

### Access Atlantis UI

```bash
./ui.sh
```

Access Atlantis at: http://localhost:4141

### Apply Terraform using Atlantis

```bash
./apply-terraform.sh
```

This will:
- Copy your local terraform files to the Atlantis pod
- Run terraform init, plan, and apply inside Atlantis
- Show you the created resources

### Stop the cluster

```bash
./stop.sh
```

## Terraform Resources

The Terraform configuration deploys:
- A namespace called "terraform-app"
- A ConfigMap with application settings
- An nginx deployment with 2 replicas
- A ClusterIP service

## Using Atlantis

This setup allows you to run Terraform through the Atlantis pod without requiring an external GitHub repository.

The `apply-terraform.sh` script:
1. Copies your local terraform/ folder to the Atlantis pod
2. Executes terraform commands using Atlantis's built-in terraform binary
3. Applies changes directly to the kind cluster

This is perfect for local development and testing.

## Configuration

### Atlantis Configuration

The `atlantis.yaml` file defines the project structure and workflows.

### Kubernetes Manifests

All Kubernetes manifests are in the `specs/` directory and will be applied automatically when running `./run.sh`.

### Terraform Configuration

The Terraform configuration in the `terraform/` directory manages Kubernetes resources using the kubernetes provider.