# Jobs with Volcano Scheduler and Queues

This folder contains Flink and Spark job examples scheduled by Volcano using queue-based resource management.

## Volcano Queues

The cluster has 4 predefined queues with different priorities and resource limits:

- **default**: weight=1, 2 CPU / 2Gi memory, reclaimable
- **high-priority**: weight=3, 4 CPU / 4Gi memory, non-reclaimable
- **low-priority**: weight=1, 1 CPU / 1Gi memory, reclaimable
- **spark-queue**: weight=2, 4 CPU / 4Gi memory, reclaimable

View queues:
```bash
kubectl get queue
```

## Available Jobs

### Spark Pi Job - Quick (uses spark-queue)
**File:** `spark-pi-simple.yaml`

Calculates Pi using Apache Spark with 1000 iterations. Completes in under 1 minute.

**Submit:**
```bash
./submit-spark.sh
```

**Monitor:**
```bash
kubectl get vcjob -n default spark-pi-simple
kubectl logs -n default -l volcano.sh/job-name=spark-pi-simple -f
```

**Delete:**
```bash
kubectl delete vcjob -n default spark-pi-simple
```

### Spark Pi Job - Long Running (uses spark-queue)
**File:** `spark-streaming-ui.yaml`

Calculates Pi with 100,000 iterations. Runs for 5+ minutes, ideal for accessing Spark UI.

**Submit:**
```bash
./submit-spark-long.sh
```

**Access Spark UI:**
```bash
./spark-ui.sh
```

**Monitor:**
```bash
kubectl get vcjob -n default spark-long-running
kubectl logs -n default -l volcano.sh/job-name=spark-long-running -f
```

**Delete:**
```bash
kubectl delete vcjob -n default spark-long-running
```

### Batch Job - WordCount
**File:** `flink-wordcount-job.yaml`

Runs a batch WordCount job on the Flink README file.

**Submit:**
```bash
./submit-batch.sh
```

**Monitor:**
```bash
kubectl get vcjob -n flink
kubectl logs -n flink -l volcano.sh/job-name=flink-batch-wordcount -f
```

**Delete:**
```bash
kubectl delete vcjob -n flink flink-batch-wordcount
```

### Streaming Job - WordCount
**File:** `flink-streaming-job.yaml`

Runs a streaming WordCount job.

**Submit:**
```bash
./submit-streaming.sh
```

**Monitor:**
```bash
kubectl get vcjob -n flink
kubectl logs -n flink -l volcano.sh/job-name=flink-streaming-wordcount -f
```

**Delete:**
```bash
kubectl delete vcjob -n flink flink-streaming-wordcount
```

## Accessing UIs

### Flink UI

The Flink UI is accessible at:
- **http://localhost:30080** (already exposed via NodePort)

Or use port-forward:
```bash
kubectl port-forward -n flink svc/flink-jobmanager 8081:8081
```
Then visit: http://localhost:8081

### Spark UI

Spark UI is only available while a Spark job is running.

**For long-running job (recommended for UI access):**
```bash
./submit-spark-long.sh
sleep 15
./spark-ui.sh
```
Then visit: http://localhost:4040

**For quick job:**
```bash
./submit-spark.sh
./spark-ui.sh
```
Note: Quick job completes in under 1 minute, so UI may not be accessible.

## Volcano Job Status

Check all Volcano jobs:
```bash
kubectl get vcjob -n flink
```

Check Volcano job details:
```bash
kubectl describe vcjob -n flink <job-name>
```

## Queue Resource Management

Jobs are scheduled based on queue priority and available resources:

**Check queue status:**
```bash
kubectl get queue
kubectl describe queue spark-queue
```

**Jobs using queues:**
- Spark jobs use `spark-queue`
- Flink jobs can be modified to use specific queues

To assign a job to a queue, add to the Volcano Job spec:
```yaml
spec:
  queue: spark-queue
```

## Custom Jobs

To create your own job with Volcano and queues:

1. Build your application JAR
2. Create a Docker image with your JAR
3. Create a Volcano Job YAML similar to the examples
4. Set `schedulerName: volcano` in the spec
5. Optionally set `queue: <queue-name>` for queue-based scheduling
6. Submit with `kubectl apply -f your-job.yaml`
