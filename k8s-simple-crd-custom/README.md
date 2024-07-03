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
```
❯ kubectl get ct -o yaml
apiVersion: v1
items:
- apiVersion: stable.example.com/v1
  kind: CronTab
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"stable.example.com/v1","kind":"CronTab","metadata":{"annotations":{},"name":"my-new-cron-object","namespace":"default"},"spec":{"cronSpec":"* * * * */5","image":"my-awesome-cron-image"}}
    creationTimestamp: "2024-07-03T09:02:33Z"
    generation: 1
    name: my-new-cron-object
    namespace: default
    resourceVersion: "758"
    uid: 4d1f7637-b41e-4331-af36-85e6fdc26405
  spec:
    cronSpec: '* * * * */5'
    image: my-awesome-cron-image
kind: List
metadata:
  resourceVersion: ""
```