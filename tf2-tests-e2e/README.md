### Install

```bash
terraform init
terraform apply
```

### Run

```bash
❯ /bin/python3 tests.py

=================================================================================== tf2 ===================================================================================
   __________   ________    _______
  |\___   ___\ |\  _____\  /  ___  \
  \|___ \  \_| \ \  \__/  /__/|_/  /|
       \ \  \   \ \   __\ |__|//  / /
        \ \  \   \ \  \_|     /  /_/__
         \ \__\   \ \__\     |\________\ Dedicated to Iran and Iranians
          \|__|    \|__|     \|________| Terraform Test Framework

platform linux, python 3.10.12
tf2 0.2.0, terraform 1.0.5, json 0.2, type stateloader
rootdir: /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/git/diegopacheco/devops-playground/tf2-tests-e2e
datapath: /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/git/diegopacheco/devops-playground/tf2-tests-e2e/terraform.tfstate
collected 2 tests

object_name: resources.docker_container.nginx
➙ test_func: test_nginx_status ✅ PASSED

object_name: resources.docker_container.nginx
➙ test_func: test_nginx_public_access ✅ PASSED

============================================================================ 2 passed in 0.07s ============================================================================
```