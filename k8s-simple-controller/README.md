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

### Output
```
❯ make run
test -s /home/diego/git/diegopacheco/devops-playground/k8s-simple-controller/bin/controller-gen && /home/diego/git/diegopacheco/devops-playground/k8s-simple-controller/bin/controller-gen --version | grep -q v0.13.0 || \
GOBIN=/home/diego/git/diegopacheco/devops-playground/k8s-simple-controller/bin go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.13.0
/home/diego/git/diegopacheco/devops-playground/k8s-simple-controller/bin/controller-gen rbac:roleName=manager-role crd webhook paths="./..." output:crd:artifacts:config=config/crd/bases
/home/diego/git/diegopacheco/devops-playground/k8s-simple-controller/bin/controller-gen object:headerFile="hack/boilerplate.go.txt" paths="./..."
go fmt ./...
go vet ./...
go run ./cmd/main.go
2024-07-03T01:47:54-07:00	INFO	setup	starting manager
2024-07-03T01:47:54-07:00	INFO	controller-runtime.metrics	Starting metrics server
2024-07-03T01:47:54-07:00	INFO	controller-runtime.metrics	Serving metrics server	{"bindAddress": ":8080", "secure": false}
2024-07-03T01:47:54-07:00	INFO	starting server	{"kind": "health probe", "addr": "[::]:8081"}
2024-07-03T01:47:54-07:00	INFO	Starting EventSource	{"controller": "pod", "controllerGroup": "", "controllerKind": "Pod", "source": "kind source: *v1.Pod"}
2024-07-03T01:47:54-07:00	INFO	Starting Controller	{"controller": "pod", "controllerGroup": "", "controllerKind": "Pod"}
2024-07-03T01:47:54-07:00	INFO	Starting workers	{"controller": "pod", "controllerGroup": "", "controllerKind": "Pod", "worker count": 1}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"coredns-7db6d8ff4d-4v67m","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"coredns-7db6d8ff4d-kdg2b","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"etcd-kind-control-plane","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"kindnet-b4qsx","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"kube-apiserver-kind-control-plane","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"kube-controller-manager-kind-control-plane","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"kube-proxy-267p2","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"kube-scheduler-kind-control-plane","namespace":"kube-system"}}
2024-07-03T01:47:54-07:00	INFO	no update required	{"pod": {"name":"local-path-provisioner-988d74bc-vvm47","namespace":"local-path-storage"}}
```
```
❯ kubectl get pod my-nginx --show-labels
NAME       READY   STATUS    RESTARTS   AGE   LABELS
my-nginx   1/1     Running   0          49s   run=my-nginx
```