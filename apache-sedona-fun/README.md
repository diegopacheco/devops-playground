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
