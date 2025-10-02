## Results

```bash
❯ ./run.sh
Creating kind cluster...
enabling experimental podman provider
Creating cluster "kyverno-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.34.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 5m0s for control-plane = Ready ⏳
 • Ready after 15s 💚
Set kubectl context to "kind-kyverno-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-kyverno-cluster

Thanks for using kind! 😊
Installing Kyverno...
namespace/kyverno created
serviceaccount/kyverno-admission-controller created
serviceaccount/kyverno-background-controller created
serviceaccount/kyverno-cleanup-controller created
serviceaccount/kyverno-cleanup-jobs created
serviceaccount/kyverno-reports-controller created
configmap/kyverno created
configmap/kyverno-metrics created
Warning: unrecognized format "int32"
Warning: unrecognized format "int64"
customresourcedefinition.apiextensions.k8s.io/admissionreports.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/backgroundscanreports.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/cleanuppolicies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusteradmissionreports.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusterbackgroundscanreports.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clustercleanuppolicies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusterpolicies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policies.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/policyexceptions.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/updaterequests.kyverno.io created
customresourcedefinition.apiextensions.k8s.io/clusterpolicyreports.wgpolicyk8s.io created
customresourcedefinition.apiextensions.k8s.io/policyreports.wgpolicyk8s.io created
clusterrole.rbac.authorization.k8s.io/kyverno:admission-controller created
clusterrole.rbac.authorization.k8s.io/kyverno:admission-controller:core created
clusterrole.rbac.authorization.k8s.io/kyverno:background-controller created
clusterrole.rbac.authorization.k8s.io/kyverno:background-controller:core created
clusterrole.rbac.authorization.k8s.io/kyverno:cleanup-controller created
clusterrole.rbac.authorization.k8s.io/kyverno:cleanup-controller:core created
clusterrole.rbac.authorization.k8s.io/kyverno-cleanup-jobs created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:admin:policies created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:view:policies created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:admin:policyreports created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:view:policyreports created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:admin:reports created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:view:reports created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:admin:updaterequests created
clusterrole.rbac.authorization.k8s.io/kyverno:rbac:view:updaterequests created
clusterrole.rbac.authorization.k8s.io/kyverno:reports-controller created
clusterrole.rbac.authorization.k8s.io/kyverno:reports-controller:core created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:admission-controller created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:background-controller created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:cleanup-controller created
clusterrolebinding.rbac.authorization.k8s.io/kyverno-cleanup-jobs created
clusterrolebinding.rbac.authorization.k8s.io/kyverno:reports-controller created
role.rbac.authorization.k8s.io/kyverno:admission-controller created
role.rbac.authorization.k8s.io/kyverno:background-controller created
role.rbac.authorization.k8s.io/kyverno:cleanup-controller created
role.rbac.authorization.k8s.io/kyverno:reports-controller created
rolebinding.rbac.authorization.k8s.io/kyverno:admission-controller created
rolebinding.rbac.authorization.k8s.io/kyverno:background-controller created
rolebinding.rbac.authorization.k8s.io/kyverno:cleanup-controller created
rolebinding.rbac.authorization.k8s.io/kyverno:reports-controller created
service/kyverno-svc created
service/kyverno-svc-metrics created
service/kyverno-background-controller-metrics created
service/kyverno-cleanup-controller created
service/kyverno-cleanup-controller-metrics created
service/kyverno-reports-controller-metrics created
deployment.apps/kyverno-admission-controller created
deployment.apps/kyverno-background-controller created
deployment.apps/kyverno-cleanup-controller created
deployment.apps/kyverno-reports-controller created
cronjob.batch/kyverno-cleanup-admission-reports created
cronjob.batch/kyverno-cleanup-cluster-admission-reports created
Waiting for Kyverno to be ready...
pod/kyverno-admission-controller-8658f777dc-6dnfj condition met
pod/kyverno-background-controller-6b588875c7-jwgkp condition met
pod/kyverno-cleanup-controller-b4d794698-mhh8l condition met
pod/kyverno-reports-controller-569b46755-kwftc condition met
Waiting for webhooks to be configured...
Applying Kyverno policies from spec/policies/ folder...
clusterpolicy.kyverno.io/add-default-resources created
clusterpolicy.kyverno.io/disallow-latest-tag created
clusterpolicy.kyverno.io/require-labels created
clusterpolicy.kyverno.io/restrict-registries created
Waiting for policies to be ready...
Waiting for all 4 policies to be ready...
Waiting for all 4 policies to be ready...
Cluster is ready!
NAME                    ADMISSION   BACKGROUND   VALIDATE ACTION   READY   AGE   MESSAGE
add-default-resources   true        true         Audit             True    2s    Ready
disallow-latest-tag     true        true         Enforce           True    2s    Ready
require-labels          true        true         Enforce           True    2s    Ready
restrict-registries     true        true         Enforce           True    2s    Ready
Kubernetes control plane is running at https://127.0.0.1:56726
CoreDNS is running at https://127.0.0.1:56726/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

```bash
❯ ./test.sh
=========================================
Testing Kyverno Policies
=========================================

1. Testing require-labels policy (should FAIL - missing labels)...
Error from server: error when creating "STDIN": admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/default/test-no-labels was blocked due to the following policies

require-labels:
  check-for-labels: 'validation error: Labels ''app'' and ''team'' are required. rule
    check-for-labels failed at path /metadata/labels/'
✓ Policy blocked pod without labels

2. Testing disallow-latest-tag policy (should FAIL - using latest tag)...
Error from server: error when creating "STDIN": admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/default/test-latest-tag was blocked due to the following policies

disallow-latest-tag:
  require-image-tag: 'validation error: Using ''latest'' tag is not allowed. Specify
    a version. rule require-image-tag failed at path /spec/containers/0/image/'
✓ Policy blocked pod with latest tag

3. Creating valid pod (should SUCCEED)...
pod/test-valid-pod created

4. Checking if resource limits were added by mutation policy...
{
  "limits": {
    "cpu": "500m",
    "memory": "512Mi"
  },
  "requests": {
    "cpu": "250m",
    "memory": "256Mi"
  }
}

5. Testing restrict-registries policy (should FAIL - unauthorized registry)...
Error from server: error when creating "STDIN": admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/default/test-bad-registry was blocked due to the following policies

restrict-registries:
  validate-registries: 'validation error: Images must come from approved registries:
    docker.io, gcr.io, or quay.io. rule validate-registries failed at path /spec/containers/0/image/'
✓ Policy blocked pod from unauthorized registry

=========================================
Cleaning up test resources...
=========================================
pod "test-valid-pod" deleted from default namespace

=========================================
Policy Validation Complete!
=========================================

Summary of policies tested:
  ✓ require-labels: Enforces app and team labels
  ✓ disallow-latest-tag: Prevents using :latest tag
  ✓ add-default-resources: Mutates pods to add resource limits
  ✓ restrict-registries: Only allows approved container registries
```