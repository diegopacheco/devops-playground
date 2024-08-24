### MetalLB

versions

```
version: v0.12.1
kubernetes: v1.30
```

### Steps 

1. Create k8s cluster

```
./k8s-kind-create-cluster.sh
```
```
❯ ./k8s-kind-create-cluster.sh
Creating cluster "cluster-mlb" ...
 ✓ Ensuring node image (kindest/node:v1.30.0) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-cluster-mlb"
You can now use your cluster with:

kubectl cluster-info --context kind-cluster-mlb

Have a nice day! 👋
Kubernetes control plane is running at https://127.0.0.1:6650
CoreDNS is running at https://127.0.0.1:6650/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
```
❯ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                      NAMES
3fcbe7209609   kindest/node:v1.30.0   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                              cluster-mlb-worker2
fab041b587c2   kindest/node:v1.30.0   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes                              cluster-mlb-worker
298373b4f44d   kindest/node:v1.30.0   "/usr/local/bin/entr…"   2 minutes ago   Up 2 minutes   127.0.0.1:6650->6443/tcp   cluster-mlb-control-plane
```

2. Deploy Echo service and MetalLB

```
./k8s-deploy.sh
```
```
❯ ./k8s-deploy.sh
namespace/metallb-system created
serviceaccount/controller created
serviceaccount/speaker created
clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
role.rbac.authorization.k8s.io/config-watcher created
role.rbac.authorization.k8s.io/pod-lister created
role.rbac.authorization.k8s.io/controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
rolebinding.rbac.authorization.k8s.io/config-watcher created
rolebinding.rbac.authorization.k8s.io/pod-lister created
rolebinding.rbac.authorization.k8s.io/controller created
daemonset.apps/speaker created
deployment.apps/controller created
resource mapping not found for name: "controller" namespace: "" from "https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml": no matches for kind "PodSecurityPolicy" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "speaker" namespace: "" from "https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml": no matches for kind "PodSecurityPolicy" in version "policy/v1beta1"
ensure CRDs are installed first
Warning: resource configmaps/kube-proxy is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
configmap/kube-proxy configured
configmap/config created
deployment.apps/echo-deployment created
service/echo-service created
deployment.apps/controller restarted
```

3. Check system pods

```
kubectl get pods -n metallb-system
kubectl get all
```
```
❯ kubectl get pods -n metallb-system

NAME                          READY   STATUS    RESTARTS   AGE
controller-5dff688c77-7mbk2   1/1     Running   0          4m56s
speaker-8rrnr                 1/1     Running   0          5m18s
speaker-frghv                 1/1     Running   0          4m57s
❯ kubectl get all

NAME                                   READY   STATUS    RESTARTS   AGE
pod/echo-deployment-7cd59d544c-9sd2s   1/1     Running   0          25m
pod/echo-deployment-7cd59d544c-w2pj9   1/1     Running   0          25m
pod/echo-deployment-7cd59d544c-w7x99   1/1     Running   0          25m

NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
service/echo-service   LoadBalancer   10.96.143.113   172.18.0.240   80:32344/TCP   5m1s
service/kubernetes     ClusterIP      10.96.0.1       <none>         443/TCP        27m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/echo-deployment   3/3     3            3           25m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/echo-deployment-7cd59d544c   3         3         3       25m
```

4. Run the application via MetalLB
```
./run-app.sh
```
```
❯ ./run-app.sh
{
  "host": {
    "hostname": "172.18.0.240",
    "ip": "::ffff:10.244.1.1",
    "ips": []
  },
  "http": {
    "method": "GET",
    "baseUrl": "",
    "originalUrl": "/",
    "protocol": "http"
  },
  "request": {
    "params": {
      "0": "/"
    },
    "query": {},
    "cookies": {},
    "body": {},
    "headers": {
      "host": "172.18.0.240",
      "user-agent": "curl/8.5.0",
      "accept": "*/*"
    }
  },
  "environment": {
    "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "HOSTNAME": "echo-deployment-7cd59d544c-w7x99",
    "NODE_VERSION": "20.11.0",
    "YARN_VERSION": "1.22.19",
    "ECHO_SERVICE_PORT_80_TCP_ADDR": "10.96.112.160",
    "KUBERNETES_SERVICE_HOST": "10.96.0.1",
    "ECHO_SERVICE_PORT_80_TCP": "tcp://10.96.112.160:80",
    "KUBERNETES_PORT_443_TCP_PORT": "443",
    "ECHO_SERVICE_SERVICE_HOST": "10.96.112.160",
    "KUBERNETES_SERVICE_PORT_HTTPS": "443",
    "KUBERNETES_PORT": "tcp://10.96.0.1:443",
    "KUBERNETES_PORT_443_TCP_ADDR": "10.96.0.1",
    "ECHO_SERVICE_SERVICE_PORT": "80",
    "ECHO_SERVICE_PORT": "tcp://10.96.112.160:80",
    "ECHO_SERVICE_PORT_80_TCP_PROTO": "tcp",
    "ECHO_SERVICE_PORT_80_TCP_PORT": "80",
    "KUBERNETES_SERVICE_PORT": "443",
    "KUBERNETES_PORT_443_TCP": "tcp://10.96.0.1:443",
    "KUBERNETES_PORT_443_TCP_PROTO": "tcp",
    "HOME": "/root"
  }
}
```