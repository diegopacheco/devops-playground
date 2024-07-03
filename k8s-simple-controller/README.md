### Provision infra

install arkade
```
curl -sLS https://get.arkade.dev | sudo sh
arkade get kubectl
```
Install operator-sdk
```
arkade get operator-sdk
kind create cluster
```

### Create Controller
```
operator-sdk init --domain=github.com --repo=github.com/busser/label-operator
operator-sdk create api --group=core --version=v1 --kind=Pod --controller=true --resource=false
```

### Run Controller in k8s
```
make run
kubectl run --image=nginx my-nginx
kubectl get pod my-nginx --show-labels
```
