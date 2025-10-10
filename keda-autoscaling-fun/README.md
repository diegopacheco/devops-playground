### Results

```
running (48.0s), 069/280 VUs, 455 complete and 0 interrupted iterations
default ↓ [ 100% ] 280 VUs  23s
Time: 44s - Pods: 3 - CPU: 41 - HPA Target: 82%/5%
SUCCESS! Scaled to 3 pods
NAME                              READY   STATUS    RESTARTS   AGE
rust-webservice-57fc4dfdc-5k9xl   1/1     Running   0          5m12s
rust-webservice-57fc4dfdc-jm5k4   0/1     Running   0          1s
rust-webservice-57fc4dfdc-jvcw5   0/1     Running   0          1s
NAME                              REFERENCE                    TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
keda-hpa-rust-webservice-scaler   Deployment/rust-webservice   cpu: 82%/5%   1         3         1          2m46s
NAME                              CPU(cores)   MEMORY(bytes)
rust-webservice-57fc4dfdc-5k9xl   41m          7Mi
Final pod count: 3
KEDA autoscaling verified: scaled from 1 to 3 pods
```

```bash
❯ kubectl get all
NAME                                  READY   STATUS    RESTARTS   AGE
pod/rust-webservice-57fc4dfdc-5k9xl   1/1     Running   0          5m29s
pod/rust-webservice-57fc4dfdc-jm5k4   1/1     Running   0          18s
pod/rust-webservice-57fc4dfdc-jvcw5   1/1     Running   0          18s

NAME                      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
service/kubernetes        ClusterIP   10.96.0.1     <none>        443/TCP    5m37s
service/rust-webservice   ClusterIP   10.96.155.1   <none>        8080/TCP   5m29s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/rust-webservice   3/3     3            3           5m29s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/rust-webservice-57fc4dfdc   3         3         3       5m29s

NAME                                                                  REFERENCE                    TARGETS        MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/keda-hpa-rust-webservice-scaler   Deployment/rust-webservice   cpu: 200%/5%   1         3         3          3m3s
```