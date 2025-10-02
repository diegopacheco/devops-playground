# Falco Runtime Security

https://falco.org/

Runtime security monitoring with Falco on Kubernetes, showing container security scenarios and metadata collection.

## What is Falco?

Falco is a cloud-native runtime security tool that detects unexpected application behavior and alerts on threats at runtime using:
- eBPF or kernel module for syscall monitoring
- Kubernetes audit events
- Cloud provider audit logs

## Structure

- `run.sh` - Creates Kind cluster and installs Falco k8s metacollector
- `test.sh` -  5 security scenarios
- `shutdown.sh` - Cleanup script
- `spec/rules/` - Custom Falco security rules (for reference)
- `spec/falco-values.yaml` - Falco Helm configuration

## Important Note

**Runs Falco WITHOUT a kernel driver** (not available in Kind/Podman).
- Falco architecture and installation
- Kubernetes metadata collection
- Security scenario identification
- What Falco would detect with full deployment

**Production Falco** (with eBPF/kernel module) provides:
- Real-time syscall monitoring
- Shell execution detection
- Suspicious file access alerts
- Network activity monitoring
- Privilege escalation detection
- Container escape attempts

## Running

```bash
./run.sh
./test.sh
./shutdown.sh
```

## Security Scenarios

1. **Privileged containers** - Full host access
2. **Host network** - Container sees host network traffic
3. **Host PID namespace** - Container sees all host processes
4. **Sensitive mounts** - Host filesystem access
5. **Secure baseline** - Properly isolated container

## What Falco Detects (with driver)

✓ Shell spawned in container
✓ Privileged container started
✓ Sensitive file access (/etc/shadow, /etc/passwd)
✓ Package management in container
✓ Unexpected network connections
✓ Container escape attempts
✓ Privilege escalation
✓ Crypto mining activity

## Learn More

- [Falco Documentation](https://falco.org/docs/)
- [Falco Rules](https://github.com/falcosecurity/rules)
- [Falco Plugins](https://github.com/falcosecurity/plugins)

## Results

```bash
❯ ./test.sh
=========================================
Falco Runtime Security 
=========================================

Shows Falco's Kubernetes Metacollector
Full runtime security requires kernel driver (not available in Kind/Podman)

Checking Falco Metacollector status...
NAME                                       READY   STATUS    RESTARTS      AGE
falco-6v52b                                1/2     Error     3 (42s ago)   71s
falco-k8s-metacollector-769fd4f6c6-nn7l7   1/1     Running   0             71s

=========================================
Container Security Scenarios
=========================================

1. Creating PRIVILEGED container...
pod/privileged-pod created
   -> Privileged containers have full host access (SECURITY RISK)

2. Creating pod with HOST NETWORK...
pod/host-network-pod created
   -> Host network allows container to see all host network traffic

3. Creating pod with HOST PID namespace...
pod/host-pid-pod created
   -> Host PID allows container to see all host processes

4. Creating pod mounting SENSITIVE host path...
pod/sensitive-mount-pod created
   -> Mounting host filesystem is a container escape vector

5. Creating SECURE pod (baseline)...
pod/secure-pod created
   -> No elevated privileges, isolated namespaces

=========================================
Kubernetes Metadata Collection
=========================================

Metacollector is tracking these pod events...
host-network-pod      1/1     Running   0          8s    security-test=high-risk
host-pid-pod          1/1     Running   0          6s    security-test=high-risk
privileged-pod        1/1     Running   0          11s   security-test=high-risk
secure-pod            1/1     Running   0          2s    security-test=secure
sensitive-mount-pod   1/1     Running   0          4s    security-test=high-risk

Metacollector logs (container metadata being collected):
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"Starting EventSource","source":"kind source: *v1.Service"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"Starting EventSource","source":"kind source: *v1.EndpointSlice"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"Starting EventSource","source":"channel source: 0x4000240f80"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"Starting EventSource","source":"channel source: 0x400035c0c0"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"Starting Controller"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicationcontroller-collector","msg":"Starting EventSource","source":"kind source: *v1.PartialObjectMetadata"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicationcontroller-collector","msg":"Starting EventSource","source":"channel source: 0x40000498c0"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicationcontroller-collector","msg":"Starting EventSource","source":"channel source: 0x4000240f00"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"namespace-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"Namespace"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"endpoint-dispatcher","msg":"Starting EventSource","source":"kind source: *v1.Endpoints"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicationcontroller-collector","msg":"Starting Controller"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"endpoint-dispatcher","msg":"Starting Controller"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicaset-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"ReplicaSet"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"daemonset-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"DaemonSet"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"service-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"Service"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"endpointslices-dispatcher","msg":"Starting EventSource","source":"kind source: *v1.EndpointSlice"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"endpointslices-dispatcher","msg":"Starting Controller"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"deployment-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"Deployment"}
{"level":"info","ts":"2025-10-02T06:40:21Z","logger":"replicationcontroller-collector","msg":"starting event dispatcher for new subscribers","resourceKind":"ReplicationController"}
W1002 06:40:21.894867       1 warnings.go:70] v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice

=========================================
Security Analysis
=========================================

HIGH RISK PODS:
NAME                  PRIVILEGED   HOST_NETWORK   HOST_PID
host-network-pod      <none>       true           <none>
host-pid-pod          <none>       <none>         true
privileged-pod        true         <none>         <none>
sensitive-mount-pod   <none>       <none>         <none>

SECURE PODS:
NAME         READY   STATUS    RESTARTS   AGE
secure-pod   1/1     Running   0          2s

=========================================
What Falco Detects (with kernel driver):
=========================================
✓ Shell spawned in container
✓ Privileged container started
✓ Sensitive file access (/etc/shadow, /etc/passwd)
✓ Package management in container (apt, yum)
✓ Unexpected network connections
✓ Container escape attempts
✓ Privilege escalation
✓ Crypto mining activity

=========================================
Cleanup
=========================================
pod "host-network-pod" deleted from default namespace
pod "host-pid-pod" deleted from default namespace
pod "privileged-pod" deleted from default namespace
pod "secure-pod" deleted from default namespace
pod "sensitive-mount-pod" deleted from default namespace

Summary:
- 5 security scenarios
- K8s Metacollector tracks container metadata
- Full Falco (with eBPF/kernel module) provides runtime threat detection
- Production: Deploy Falco with driver for complete security monitoring

Learn more: https://falco.org/docs/
```