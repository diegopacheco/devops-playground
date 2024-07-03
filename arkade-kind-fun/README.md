### install Arkade
```bash
curl -sLS https://get.arkade.dev | sudo sh
```

### Install K8s Tools
```bash
arkade get kubectl helm faas-cli istioctl
```

### Create K8s Cluster
```bash
kind create cluster
```

### Using K8s Cluster
```bash
kind get clusters
docker ps
kubectl get nodes
kubectl cluster-info --context kind-kind
kubectl cluster-info dump --context kind-kind
kind delete cluster --name kind-kind
```

Create Ingress Controller
```
kind create cluster --config specs/ingress-controller.yaml
```