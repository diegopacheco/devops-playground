# Install KubeAssert

```bash
curl -L https://raw.githubusercontent.com/morningspace/kubeassert/master/kubectl-assert.sh -o kubectl-assert
chmod +x kubectl-assert
./kubectl-assert
```

## Test Result

```bash
❯ ./test.sh
Running kubectl-assert tests
Test 1: Assert nginx deployment exists
ASSERT deployment nginx-deployment should exist.
INFO   Found 1 resource(s).
deployment.apps/nginx-deployment
ASSERT PASS
Test 2: Assert nginx deployment exists in default namespace
ASSERT deployment nginx-deployment should exist.
INFO   Found 1 resource(s).
deployment.apps/nginx-deployment
ASSERT PASS
Test 3: Assert nginx service exists
ASSERT service nginx-service should exist.
INFO   Found 1 resource(s).
service/nginx-service
ASSERT PASS
Test 4: Assert nginx pods exist with label app=nginx
ASSERT pods matching label criteria 'app=nginx' should exist.
INFO   Found 2 resource(s).
pod/nginx-deployment-77bf8679f9-8vj9g
pod/nginx-deployment-77bf8679f9-d9qnv
ASSERT PASS
Test 5: Assert nginx pods are running
ASSERT pods matching label criteria 'app=nginx' and field criteria 'status.phase=Running' should exist.
INFO   Found 2 resource(s).
pod/nginx-deployment-77bf8679f9-8vj9g
pod/nginx-deployment-77bf8679f9-d9qnv
ASSERT PASS
Test 6: Assert all resources with app=nginx label exist
ASSERT deployment,service,pods matching label criteria 'app=nginx' should exist.
INFO   Found 2 resource(s).
pod/nginx-deployment-77bf8679f9-8vj9g
pod/nginx-deployment-77bf8679f9-d9qnv
ASSERT PASS
All tests passed successfully!
```