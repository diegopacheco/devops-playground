# CDK8s Nginx Deployment on Kind

This project demonstrates how to deploy nginx to a local Kubernetes cluster using Kind and CDK8s with JavaScript.

## Prerequisites

- Docker
- Kind (Kubernetes in Docker)
- kubectl
- Node.js and npm

## Quick Start

### 1. Create the Kubernetes cluster
```bash
chmod +x run.sh
./run.sh
```

### 2. Deploy nginx using CDK8s
```bash
chmod +x test.sh
./test.sh
```

### 3. Access nginx
Open your browser and go to: http://localhost:8080

### 4. Clean up
```bash
chmod +x stop.sh
./stop.sh
```

## What's Included

- **run.sh**: Creates a Kind cluster named `cdk8s-cluster`
- **stop.sh**: Destroys the Kind cluster
- **test.sh**: Installs dependencies, generates K8s manifests with CDK8s, deploys nginx, and shows deployed pods
- **main.js**: CDK8s application that defines nginx deployment with 2 replicas and a NodePort service
- **package.json**: Node.js dependencies for CDK8s

## How it Works

1. CDK8s generates Kubernetes YAML manifests from JavaScript code
2. The manifests are saved to the `dist/` directory
3. kubectl applies the manifests to your Kind cluster
4. Nginx is exposed via NodePort on port 30080 (mapped to host port 8080)

## Commands

View pods:
```bash
kubectl get pods
```

View services:
```bash
kubectl get services
```

View logs:
```bash
kubectl logs -l app=nginx-deployment-c8b367ce
```

Delete deployment:
```bash
kubectl delete -f dist/
```
