### CPU limits

Example Snippet (deployment.yaml):
```yaml
spec:
    containers:
    - name: myapp
    image: myapp-image:latest
    resources:
        requests:
        cpu: "500m"  # 0.5 CPU
        limits:
        cpu: "1"     # 1 vCPU
```

**requests.cpu** specifies the amount of CPU guaranteed to the container. <br/>
**limits.cpu** specifies the maximum amount of CPU the container can use.

Key Highlights:

* In Kubernetes, CPU resources are measured in units of "CPU" or "millicores."
* 1 CPU in Kubernetes is equivalent to 1 vCPU/Core for cloud providers (like AWS, GCP) or 1 hyperthread on bare-metal Intel processors.
* 500m (millicores) means 500 thousandths of a CPU, or 0.5 CPU.
* If a pod exceeds its CPU limit, Kubernetes will simply throttle the pod. This means that the pod will be given less CPU time, which can slow down the pod's performance.
* AWS Fargate adds 256 MB to each Pod's memory reservation for the required Kubernetes components (kubelet, kube-proxy, and containerd).
* AWS EKS Fargate runs only one Pod per node.
* All AWS EKS Fargate Pods run with guaranteed priority, so the requested CPU and memory must be equal to the limit for all of the containers
* Table:

```
5000m = 5 CPU
4500m = 4.5 CPU
4000m = 4 CPU
3500m = 3.5 CPU
3000m = 3 CPU
2500m = 2.5 CPU
2000m = 2 CPU
1500m = 1.5 CPU
1000m = 1 CPU
500m = 0.5 CPU
250m = 0.25 CPU
200m = 0.2 CPU
100m = 0.1 CPU
50m = 0.05 CPU
10m = 0.01 CPU
1m = 0.001 CPU
```

Links

* https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/
* https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
* https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/
* https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
* https://stackoverflow.com/questions/64649585/how-to-limit-the-memory-size-of-the-instance-of-eks-fargate