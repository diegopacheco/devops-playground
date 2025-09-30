# KUTTL

## Install

```bash
brew tap kudobuilder/tap
brew install kuttl-cli
```

## Test Results

```bash
❯ ./test.sh
Running kuttl tests...
=== RUN   kuttl
    harness.go:459: starting setup
    harness.go:254: running tests using configured kubeconfig.
    harness.go:277: Successful connection to cluster at: https://127.0.0.1:61205
    harness.go:362: running tests
    harness.go:74: going to run test suite with timeout of 30 seconds for each step
    harness.go:374: testsuite: tests/ has 1 tests
=== RUN   kuttl/harness
=== RUN   kuttl/harness/nginx-test
=== PAUSE kuttl/harness/nginx-test
=== CONT  kuttl/harness/nginx-test
    logger.go:42: 20:44:11 | nginx-test | Creating namespace: kuttl-test-quick-finch
    logger.go:42: 20:44:11 | nginx-test/0-install | starting test step 0-install
    logger.go:42: 20:44:11 | nginx-test/0-install | Deployment:kuttl-test-quick-finch/nginx-deployment created
    logger.go:42: 20:44:11 | nginx-test/0-install | Service:kuttl-test-quick-finch/nginx-service created
    logger.go:42: 20:44:14 | nginx-test/0-install | test step completed 0-install
    logger.go:42: 20:44:14 | nginx-test | nginx-test events from ns kuttl-test-quick-finch:
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:12 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-6g2q9		Scheduled	Successfully assigned kuttl-test-quick-finch/nginx-deployment-7554bc5d7b-6g2q9 to kuttl-test-control-plane	default-scheduler
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:12 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-hzh6k		Scheduled	Successfully assigned kuttl-test-quick-finch/nginx-deployment-7554bc5d7b-hzh6k to kuttl-test-control-plane	default-scheduler
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:12 -0700 PDT	Normal	ReplicaSet.apps nginx-deployment-7554bc5d7b	SuccessfulCreate	Created pod: nginx-deployment-7554bc5d7b-hzh6k	replicaset-controller
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:12 -0700 PDT	Normal	ReplicaSet.apps nginx-deployment-7554bc5d7b	SuccessfulCreate	Created pod: nginx-deployment-7554bc5d7b-6g2q9	replicaset-controller
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:12 -0700 PDT	Normal	Deployment.apps nginx-deployment		ScalingReplicaSet	Scaled up replica set nginx-deployment-7554bc5d7b from 0 to 2	deployment-controller
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:13 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-6g2q9.spec.containers{nginx}		Pulling	Pulling image "nginx:latest"	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:13 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-6g2q9.spec.containers{nginx}		Pulled	Successfully pulled image "nginx:latest" in 678ms (678ms including waiting). Image size: 68869222 bytes.	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:13 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-6g2q9.spec.containers{nginx}		Created	Created container: nginx	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:13 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-6g2q9.spec.containers{nginx}		Started	Started container nginx	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:13 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-hzh6k.spec.containers{nginx}		Pulling	Pulling image "nginx:latest"	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:14 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-hzh6k.spec.containers{nginx}		Pulled	Successfully pulled image "nginx:latest" in 768ms (1.444s including waiting). Image size: 68869222 bytes.	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:14 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-hzh6k.spec.containers{nginx}		Created	Created container: nginx	kubelet
    logger.go:42: 20:44:14 | nginx-test | 2025-09-29 20:09:14 -0700 PDT	Normal	Pod nginx-deployment-7554bc5d7b-hzh6k.spec.containers{nginx}		Started	Started container nginx	kubelet
    logger.go:42: 20:44:14 | nginx-test | Deleting namespace: kuttl-test-quick-finch
=== NAME  kuttl
    harness.go:403: run tests finished
    harness.go:510: cleaning up
    harness.go:567: removing temp folder: ""
--- PASS: kuttl (8.16s)
    --- PASS: kuttl/harness (0.00s)
        --- PASS: kuttl/harness/nginx-test (8.16s)
PASS
```