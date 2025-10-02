# OPA

http://www.openpolicyagent.org/

## Results

Run
```bash
❯ ./run.sh
Creating kind cluster...
enabling experimental podman provider
Creating cluster "opa-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.34.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 5m0s for control-plane = Ready ⏳
 • Ready after 17s 💚
Set kubectl context to "kind-opa-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-opa-cluster

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
Installing OPA Gatekeeper...
namespace/gatekeeper-system created
resourcequota/gatekeeper-critical-pods created
Warning: unrecognized format "int64"
customresourcedefinition.apiextensions.k8s.io/assign.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignimage.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignmetadata.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplate.expansion.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/modifyset.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/mutatorpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/providers.externaldata.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
poddisruptionbudget.policy/gatekeeper-controller-manager created
mutatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-mutating-webhook-configuration created
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
Waiting for Gatekeeper to be ready...
Waiting for at least 2 controller pods to be ready...
Waiting for controller pods...
Waiting for controller pods...
Waiting for controller pods...
pod/gatekeeper-audit-6cb977c96f-v7nw6 condition met
Waiting for Gatekeeper webhooks to be configured...
Applying OPA constraint templates from spec/templates/ folder...
constrainttemplate.templates.gatekeeper.sh/k8sdisallowlatesttag created
constrainttemplate.templates.gatekeeper.sh/k8srequiredlabels created
constrainttemplate.templates.gatekeeper.sh/k8sallowedrepos created
Waiting for constraint templates to be ready...
Applying OPA constraints from spec/constraints/ folder...
k8sdisallowlatesttag.constraints.gatekeeper.sh/pod-disallow-latest-tag created
k8srequiredlabels.constraints.gatekeeper.sh/pod-must-have-labels created
k8sallowedrepos.constraints.gatekeeper.sh/pod-allowed-registries created
Waiting for constraints to be ready...
Cluster is ready!
NAME                   AGE
k8sallowedrepos        8s
k8sdisallowlatesttag   8s
k8srequiredlabels      8s

NAME                                                               ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8sallowedrepos.constraints.gatekeeper.sh/pod-allowed-registries

NAME                                                                     ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8sdisallowlatesttag.constraints.gatekeeper.sh/pod-disallow-latest-tag

NAME                                                               ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8srequiredlabels.constraints.gatekeeper.sh/pod-must-have-labels
Kubernetes control plane is running at https://127.0.0.1:59465
CoreDNS is running at https://127.0.0.1:59465/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

Test
```bash
❯ ./test.sh
=========================================
Testing OPA Gatekeeper Policies
=========================================

1. Testing require-labels policy (should FAIL - missing labels)...
Error from server (Forbidden): error when creating "STDIN": admission webhook "validation.gatekeeper.sh" denied the request: [pod-must-have-labels] Labels '{"app", "team"}' are required
✓ Policy blocked pod without labels

2. Testing disallow-latest-tag policy (should FAIL - using latest tag)...
Error from server (Forbidden): error when creating "STDIN": admission webhook "validation.gatekeeper.sh" denied the request: [pod-disallow-latest-tag] Using 'latest' tag is not allowed. Specify a version for image: nginx:latest
✓ Policy blocked pod with latest tag

3. Creating valid pod (should SUCCEED)...
pod/test-valid-pod created

4. Verifying pod was created successfully...
NAME             READY   STATUS              RESTARTS   AGE
test-valid-pod   0/1     ContainerCreating   0          0s

5. Testing restrict-registries policy (should FAIL - unauthorized registry)...
Error from server (Forbidden): error when creating "STDIN": admission webhook "validation.gatekeeper.sh" denied the request: [pod-allowed-registries] Container image malicious.registry.com/app:1.0 comes from an unauthorized registry. Allowed registries: ["docker.io/", "gcr.io/", "quay.io/", "nginx:", "redis:", "postgres:"]
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
  ✓ restrict-registries: Only allows approved container registries
```