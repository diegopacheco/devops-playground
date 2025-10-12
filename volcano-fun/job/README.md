# Flink Jobs with Volcano Scheduler

This folder contains Flink job examples scheduled by Volcano.

## Available Jobs

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

## Accessing Flink UI

The Flink UI is accessible at:
- **http://localhost:30080** (already exposed via NodePort)

Or use port-forward:
```bash
kubectl port-forward -n flink svc/flink-jobmanager 8081:8081
```
Then visit: http://localhost:8081

## Volcano Job Status

Check all Volcano jobs:
```bash
kubectl get vcjob -n flink
```

Check Volcano job details:
```bash
kubectl describe vcjob -n flink <job-name>
```

## Custom Jobs

To create your own Flink job with Volcano:

1. Build your Flink application JAR
2. Create a Docker image with your JAR
3. Create a Volcano Job YAML similar to the examples
4. Set `schedulerName: volcano` in the spec
5. Submit with `kubectl apply -f your-job.yaml`
