### Install

```bash
pip install tf2project
```

### Run tests

```bash
terraform init
terraform plan -out terraform.tfplan
```

### Results

```bash
❯ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/kubernetes...
- Installing hashicorp/kubernetes v2.35.1...
- Installed hashicorp/kubernetes v2.35.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
❯ terraform plan -out terraform.tfplan


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kubernetes_deployment.nginx_deployment will be created
  + resource "kubernetes_deployment" "nginx_deployment" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "app.kubernetes.io/created-by" = "tf2project"
              + "app.kubernetes.io/name"       = "nginx"
            }
          + name             = "nginx"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "1"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app.kubernetes.io/created-by" = "tf2project"
                  + "app.kubernetes.io/name"       = "nginx"
                }
            }

          + strategy {
              + type = (known after apply)

              + rolling_update {
                  + max_surge       = (known after apply)
                  + max_unavailable = (known after apply)
                }
            }

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app.kubernetes.io/created-by" = "tf2project"
                      + "app.kubernetes.io/name"       = "nginx"
                    }
                  + name             = (known after apply)
                  + resource_version = (known after apply)
                  + uid              = (known after apply)
                }

              + spec {
                  + automount_service_account_token  = true
                  + dns_policy                       = "ClusterFirst"
                  + enable_service_links             = true
                  + host_ipc                         = false
                  + host_network                     = false
                  + host_pid                         = false
                  + hostname                         = (known after apply)
                  + node_name                        = (known after apply)
                  + restart_policy                   = "Always"
                  + scheduler_name                   = (known after apply)
                  + service_account_name             = (known after apply)
                  + share_process_namespace          = false
                  + termination_grace_period_seconds = 30

                  + container {
                      + image                      = "nginx:latest"
                      + image_pull_policy          = (known after apply)
                      + name                       = "nginx"
                      + stdin                      = false
                      + stdin_once                 = false
                      + termination_message_path   = "/dev/termination-log"
                      + termination_message_policy = (known after apply)
                      + tty                        = false

                      + port {
                          + container_port = 80
                          + protocol       = "TCP"
                        }

                      + resources {
                          + limits   = (known after apply)
                          + requests = (known after apply)
                        }
                    }

                  + image_pull_secrets {
                      + name = (known after apply)
                    }

                  + readiness_gate {
                      + condition_type = (known after apply)
                    }
                }
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: terraform.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "terraform.tfplan"
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
tf2 0.2.0, terraform 1.0.5, json 0.2, type planloader
rootdir: /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/git/diegopacheco/devops-playground/tf2-tests
datapath: /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/git/diegopacheco/devops-playground/tf2-tests/terraform.tfplan
collected 4 tests

object_name: resources.kubernetes_deployment.nginx_deployment
➙ test_func: test_nginx_namespace_not_default ❌ FAILED

============================================================================ 1 failed in 0.0s ============================================================================
```