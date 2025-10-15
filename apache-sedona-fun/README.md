# Apache Sedona with Apache Flink on Kubernetes

This project deploys Apache Flink 1.19 with Apache Sedona 1.7.1 on a local Kubernetes cluster using kind.

## Components

- **Flink JobManager**: Manages job execution
- **Flink TaskManagers**: Execute tasks (2 replicas)
- **Apache Sedona**: Spatial data processing library integrated with Flink

## Files

- `Dockerfile`: Flink image with Sedona JARs
- `run.sh`: Creates kind cluster, builds image, deploys to K8s
- `stop.sh`: Cleans up cluster
- `ui.sh`: Opens Flink web UI via port-forwarding
- `specs/`: Kubernetes manifests

## Usage

### Start the Cluster

```bash
./run.sh
```

This will:
1. Create a kind cluster
2. Build Docker image with Flink + Sedona
3. Deploy to Kubernetes
4. Wait for all pods to be ready

### View Flink UI

```bash
./ui.sh
```

Access the UI at http://localhost:8081

### Stop the Cluster

```bash
./stop.sh
```

## Important Note: Sedona Function Registration

Apache Sedona requires programmatic initialization using `SedonaContext.create()` to register spatial functions. The Flink SQL CLI cannot initialize Sedona functions directly, even though the Sedona JARs are in the classpath.

To use Sedona functions, you need to:

1. Write a Java/Scala application that:
   - Creates a StreamExecutionEnvironment
   - Creates a StreamTableEnvironment
   - Calls `SedonaContext.create(env, tableEnv)`
   - Executes your spatial SQL queries

2. Package and submit the application as a Flink job

The cluster is properly configured and ready to run Sedona applications submitted as JAR files.

## Cluster Details

- **Namespace**: flink-sedona
- **JobManager UI**: http://localhost:8081 (via port-forward)
- **Flink Version**: 1.19
- **Sedona Version**: 1.7.1
- **Task Slots per TaskManager**: 4
- **TaskManager Replicas**: 2

## Verifying the Cluster

Check pods are running:
```bash
kubectl get pods -n flink-sedona
```

Check services:
```bash
kubectl get svc -n flink-sedona
```

View JobManager logs:
```bash
kubectl logs -n flink-sedona -l component=jobmanager
```

### Results

```
❯ ./clean-restart.sh
=== Clean Restart & Fast Test ===
1. Building JAR...
WARNING: A terminally deprecated method in sun.misc.Unsafe has been called
WARNING: sun.misc.Unsafe::staticFieldBase has been called by com.google.inject.internal.aop.HiddenClassDefiner (file:/opt/homebrew/Cellar/maven/3.9.11/libexec/lib/guice-5.1.0-classes.jar)
WARNING: Please consider reporting this to the maintainers of class com.google.inject.internal.aop.HiddenClassDefiner
WARNING: sun.misc.Unsafe::staticFieldBase will be removed in a future release
2. Building Docker image...
ad2f0118eba4583ff3710a3a972a68e2d162eda9f4c54547f7d3400dbb5a0f96
3. Loading into kind...
enabling experimental podman provider
4. Deleting ALL Flink pods...
pod "flink-jobmanager-6854c758cf-sx96z" deleted from flink-sedona namespace
pod "flink-taskmanager-7f58ffd85b-hz7w7" deleted from flink-sedona namespace
pod "flink-taskmanager-7f58ffd85b-kj255" deleted from flink-sedona namespace
5. Waiting for pods to restart...
pod/flink-jobmanager-6854c758cf-5sqh9 condition met
pod/flink-taskmanager-7f58ffd85b-6fghb condition met
pod/flink-taskmanager-7f58ffd85b-xrbgz condition met
6. Checking cluster status...
NAME                                 READY   STATUS    RESTARTS   AGE
flink-jobmanager-6854c758cf-5sqh9    1/1     Running   0          11s
flink-taskmanager-7f58ffd85b-6fghb   1/1     Running   0          11s
flink-taskmanager-7f58ffd85b-xrbgz   1/1     Running   0          11s
7. Waiting for cluster to stabilize...
8. Submitting job...

======================================
ERROR StatusLogger Reconfiguration failed: No configuration found for '30946e09' at 'null' in 'null'
ERROR StatusLogger Reconfiguration failed: No configuration found for '1df8da7a' at 'null' in 'null'
=== Apache Sedona Ultra-Simple Test ===
Job has been submitted with JobID aeb61b339bb5feb3977f5533ab53d541
=== ✅ SUCCESS! Sedona query executed ===
=== Completed in 815ms ===
=== Expected: POINT (1 2) ===

======================================
✅ Completed in 2 seconds!
======================================
❯ ./ui.sh
Starting port-forward to Flink JobManager UI...
Access the UI at: http://localhost:8081
Press Ctrl+C to stop port-forwarding

Forwarding from 127.0.0.1:8081 -> 8081
Forwarding from [::1]:8081 -> 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
Handling connection for 8081
```