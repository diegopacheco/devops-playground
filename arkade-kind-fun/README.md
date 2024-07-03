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

Make sure nothing is running on port 80
```bash
sudo lsof -i :80
```

Create/Deploy Ingress Controller
```
kind create cluster --config specs/ingress-controller.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Check containers
```bash
kubectl get all -n ingress-nginx
```

deploy service
```
kubectl apply -f specs/service.yaml
kubectl get services
```

Call the service
```
❯ curl -i localhost/api
HTTP/1.1 200 OK
Date: Wed, 03 Jul 2024 08:02:43 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 57
Connection: keep-alive
X-App-Name: http-echo
X-App-Version: 0.2.3

Hello World! This is a Baeldung Kubernetes with kind App

```