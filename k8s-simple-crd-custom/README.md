### Provision infra

install arkade
```
curl -sLS https://get.arkade.dev | sudo sh
arkade get kubectl
kind create cluster
```

### Create custom CRD
```
kubectl apply -f specs/resourcedefinition.yaml
kubectlget crd
```
```
NAME                          CREATED AT
crontabs.stable.example.com   2024-07-03T09:00:24Z
```

### Create custom object
```
kubectl apply -f specs/my-crontab.yaml
kubectl get crontab
```
```
NAME                 AGE
my-new-cron-object   22s
```