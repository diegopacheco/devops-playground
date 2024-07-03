### Provision infra

install arkade, create kind cluster.
```
curl -sLS https://get.arkade.dev | sudo sh
arkade get kubectl
kind create cluster
```

### Play with ConfigMaps and properties
```
kubectl apply -f configmap.yaml
kubectl apply -f pod.yaml
```