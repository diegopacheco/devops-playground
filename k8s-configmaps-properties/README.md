### Provision infra

install arkade, create kind cluster.
```
curl -sLS https://get.arkade.dev | sudo sh
arkade get kubectl
kind create cluster
```

### Play with ConfigMaps and properties
```
kubectl apply -f specs/config.yaml
kubectl apply -f specs/pod.yaml
```
```
❯ kubectl get configmap
NAME               DATA   AGE
game-demo          4      13s
kube-root-ca.crt   1      73s
```
```
kubectl get configmap game-demo -o yaml
```
```
❯ k get configmap game-demo -o yaml
apiVersion: v1
data:
  game.properties: "enemy.types=aliens,monsters\nplayer.maximum-lives=5    \n"
  player_initial_lives: "3"
  ui_properties_file_name: user-interface.properties
  user-interface.properties: "color.good=purple\ncolor.bad=yellow\nallow.textmode=true
    \   \n"
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"game.properties":"enemy.types=aliens,monsters\nplayer.maximum-lives=5    \n","player_initial_lives":"3","ui_properties_file_name":"user-interface.properties","user-interface.properties":"color.good=purple\ncolor.bad=yellow\nallow.textmode=true    \n"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"game-demo","namespace":"default"}}
  creationTimestamp: "2024-07-03T09:16:04Z"
  name: game-demo
  namespace: default
  resourceVersion: "512"
  uid: 7e70c9f2-be6c-464f-829b-3f6c81c4f9d7
```