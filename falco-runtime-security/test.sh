#!/bin/bash

set -e

echo "========================================="
echo "Falco Runtime Security
echo "========================================="

echo ""
echo "Shows Falco's Kubernetes Metacollector"
echo "Full runtime security requires kernel driver (not available in Kind/Podman)"
echo ""

echo "Checking Falco Metacollector status..."
kubectl get pods -n falco

echo ""
echo "========================================="
echo "Container Security Scenarios"
echo "========================================="

echo ""
echo "1. Creating PRIVILEGED container..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
  labels:
    security-test: "high-risk"
spec:
  containers:
  - name: nginx
    image: nginx:1.23
    securityContext:
      privileged: true
EOF
echo "   -> Privileged containers have full host access (SECURITY RISK)"

sleep 2

echo ""
echo "2. Creating pod with HOST NETWORK..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: host-network-pod
  labels:
    security-test: "high-risk"
spec:
  hostNetwork: true
  containers:
  - name: nginx
    image: nginx:1.23
EOF
echo "   -> Host network allows container to see all host network traffic"

sleep 2

echo ""
echo "3. Creating pod with HOST PID namespace..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: host-pid-pod
  labels:
    security-test: "high-risk"
spec:
  hostPID: true
  containers:
  - name: nginx
    image: nginx:1.23
EOF
echo "   -> Host PID allows container to see all host processes"

sleep 2

echo ""
echo "4. Creating pod mounting SENSITIVE host path..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sensitive-mount-pod
  labels:
    security-test: "high-risk"
spec:
  containers:
  - name: nginx
    image: nginx:1.23
    volumeMounts:
    - name: hostfs
      mountPath: /hostfs
      readOnly: true
  volumes:
  - name: hostfs
    hostPath:
      path: /
EOF
echo "   -> Mounting host filesystem is a container escape vector"

sleep 2

echo ""
echo "5. Creating SECURE pod (baseline)..."
kubectl run secure-pod --image=nginx:1.23 --labels=security-test=secure
echo "   -> No elevated privileges, isolated namespaces"

sleep 2

echo ""
echo "========================================="
echo "Kubernetes Metadata Collection"
echo "========================================="

echo ""
echo "Metacollector is tracking these pod events..."
kubectl get pods --show-labels | grep security-test

echo ""
echo "Metacollector logs (container metadata being collected):"
kubectl logs -n falco -l app.kubernetes.io/name=k8s-metacollector --tail=30 | head -20

echo ""
echo "========================================="
echo "Security Analysis"
echo "========================================="

echo ""
echo "HIGH RISK PODS:"
kubectl get pods -l security-test=high-risk -o custom-columns=NAME:.metadata.name,PRIVILEGED:.spec.containers[0].securityContext.privileged,HOST_NETWORK:.spec.hostNetwork,HOST_PID:.spec.hostPID

echo ""
echo "SECURE PODS:"
kubectl get pods -l security-test=secure

echo ""
echo "========================================="
echo "What Falco Detects (with kernel driver):"
echo "========================================="
echo "✓ Shell spawned in container"
echo "✓ Privileged container started"
echo "✓ Sensitive file access (/etc/shadow, /etc/passwd)"
echo "✓ Package management in container (apt, yum)"
echo "✓ Unexpected network connections"
echo "✓ Container escape attempts"
echo "✓ Privilege escalation"
echo "✓ Crypto mining activity"

echo ""
echo "========================================="
echo "Cleanup"
echo "========================================="

kubectl delete pods -l security-test --ignore-not-found=true

echo ""
echo ""
echo "Summary:"
echo "- 5 security scenarios"
echo "- K8s Metacollector tracks container metadata"
echo "- Full Falco (with eBPF/kernel module) provides runtime threat detection"
echo "- Production: Deploy Falco with driver for complete security monitoring"
echo ""
echo "Learn more: https://falco.org/docs/"
