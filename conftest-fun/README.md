### Installl

```bash
brew install conftest
```

### Run and Results

```bash
conftest test deployment.yaml
```

```
❯ conftest test deployment.yaml
FAIL - deployment.yaml - main - Containers must not run as root
FAIL - deployment.yaml - main - Containers must provide app label for pod selectors

2 tests, 0 passed, 0 warnings, 2 failures, 0 exceptions
```

```
❯ conftest test main.tf
FAIL - main.tf - main - AWS access key should not be hardcoded
FAIL - main.tf - main - AWS secret key should not be hardcoded
FAIL - main.tf - main - RDS instance is publicly accessible
FAIL - main.tf - main - RDS instance storage is not encrypted
FAIL - main.tf - main - RDS instance uses plaintext password
FAIL - main.tf - main - S3 bucket is publicly accessible

10 tests, 4 passed, 0 warnings, 6 failures, 0 exceptions
```