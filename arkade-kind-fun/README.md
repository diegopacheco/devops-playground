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

```