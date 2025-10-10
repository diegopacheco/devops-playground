# Atlantis Terraform on Kubernetes

This project sets up a local Kubernetes cluster using kind with Atlantis to manage Terraform deployments.

## Results

```
❯ ./watch-and-apply.sh
Watching terraform/ folder for changes...
Changes will trigger automatic terraform apply
Press Ctrl+C to stop

Changes detected! Running terraform apply...
Cleaning up old terraform files...
Copying terraform files to Atlantis pod...
Running terraform init...
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/kubernetes versions matching "~> 2.35"...
- Installing hashicorp/kubernetes v2.38.0...
- Installed hashicorp/kubernetes v2.38.0 (signed by HashiCorp)
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
Running terraform plan...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kubernetes_config_map.app_config will be created
  + resource "kubernetes_config_map" "app_config" {
      + data = {
          + "app_name"    = "terraform-managed-app"
          + "environment" = "production"
          + "version"     = "1.0.0"
        }
      + id   = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "app-config"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_deployment.app will be created
  + resource "kubernetes_deployment" "app" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + name             = "nginx-app"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "2"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "nginx"
                }
            }

          + strategy (known after apply)

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app" = "nginx"
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

                      + env_from {
                          + config_map_ref {
                              + name = "app-config"
                            }
                        }

                      + port {
                          + container_port = 80
                          + protocol       = "TCP"
                        }

                      + resources (known after apply)
                    }

                  + image_pull_secrets (known after apply)

                  + readiness_gate (known after apply)
                }
            }
        }
    }

  # kubernetes_namespace.app will be created
  + resource "kubernetes_namespace" "app" {
      + id                               = (known after apply)
      + wait_for_default_service_account = false

      + metadata {
          + generation       = (known after apply)
          + name             = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_service.app will be created
  + resource "kubernetes_service" "app" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = "nginx-service"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + allocate_load_balancer_node_ports = true
          + cluster_ip                        = (known after apply)
          + cluster_ips                       = (known after apply)
          + external_traffic_policy           = (known after apply)
          + health_check_node_port            = (known after apply)
          + internal_traffic_policy           = (known after apply)
          + ip_families                       = (known after apply)
          + ip_family_policy                  = (known after apply)
          + publish_not_ready_addresses       = false
          + selector                          = {
              + "app" = "nginx"
            }
          + session_affinity                  = "None"
          + type                              = "ClusterIP"

          + port {
              + node_port   = (known after apply)
              + port        = 80
              + protocol    = "TCP"
              + target_port = "80"
            }

          + session_affinity_config (known after apply)
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + configmap_data  = {
      + app_name    = "terraform-managed-app"
      + environment = "production"
      + version     = "1.0.0"
    }
  + deployment_name = "nginx-app"
  + namespace_name  = "terraform-app"
  + service_name    = "nginx-service"

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.

Running terraform apply...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kubernetes_config_map.app_config will be created
  + resource "kubernetes_config_map" "app_config" {
      + data = {
          + "app_name"    = "terraform-managed-app"
          + "environment" = "production"
          + "version"     = "1.0.0"
        }
      + id   = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "app-config"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_deployment.app will be created
  + resource "kubernetes_deployment" "app" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + name             = "nginx-app"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "2"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "nginx"
                }
            }

          + strategy (known after apply)

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app" = "nginx"
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

                      + env_from {
                          + config_map_ref {
                              + name = "app-config"
                            }
                        }

                      + port {
                          + container_port = 80
                          + protocol       = "TCP"
                        }

                      + resources (known after apply)
                    }

                  + image_pull_secrets (known after apply)

                  + readiness_gate (known after apply)
                }
            }
        }
    }

  # kubernetes_namespace.app will be created
  + resource "kubernetes_namespace" "app" {
      + id                               = (known after apply)
      + wait_for_default_service_account = false

      + metadata {
          + generation       = (known after apply)
          + name             = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
    }

  # kubernetes_service.app will be created
  + resource "kubernetes_service" "app" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = "nginx-service"
          + namespace        = "terraform-app"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + allocate_load_balancer_node_ports = true
          + cluster_ip                        = (known after apply)
          + cluster_ips                       = (known after apply)
          + external_traffic_policy           = (known after apply)
          + health_check_node_port            = (known after apply)
          + internal_traffic_policy           = (known after apply)
          + ip_families                       = (known after apply)
          + ip_family_policy                  = (known after apply)
          + publish_not_ready_addresses       = false
          + selector                          = {
              + "app" = "nginx"
            }
          + session_affinity                  = "None"
          + type                              = "ClusterIP"

          + port {
              + node_port   = (known after apply)
              + port        = 80
              + protocol    = "TCP"
              + target_port = "80"
            }

          + session_affinity_config (known after apply)
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + configmap_data  = {
      + app_name    = "terraform-managed-app"
      + environment = "production"
      + version     = "1.0.0"
    }
  + deployment_name = "nginx-app"
  + namespace_name  = "terraform-app"
  + service_name    = "nginx-service"
kubernetes_namespace.app: Creating...
kubernetes_namespace.app: Creation complete after 0s [id=terraform-app]
kubernetes_config_map.app_config: Creating...
kubernetes_service.app: Creating...
kubernetes_config_map.app_config: Creation complete after 0s [id=terraform-app/app-config]
kubernetes_service.app: Creation complete after 0s [id=terraform-app/nginx-service]
kubernetes_deployment.app: Creating...
kubernetes_deployment.app: Creation complete after 7s [id=terraform-app/nginx-app]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

configmap_data = tomap({
  "app_name" = "terraform-managed-app"
  "environment" = "production"
  "version" = "1.0.0"
})
deployment_name = "nginx-app"
namespace_name = "terraform-app"
service_name = "nginx-service"

Terraform applied successfully!

Checking created resources:
NAME            STATUS   AGE
terraform-app   Active   8s
NAME                             READY   STATUS    RESTARTS   AGE
pod/nginx-app-68bd4d4f75-5zhfq   1/1     Running   0          8s
pod/nginx-app-68bd4d4f75-chgdt   1/1     Running   0          8s

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/nginx-service   ClusterIP   10.96.25.163   <none>        80/TCP    8s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-app   2/2     2            2           8s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-app-68bd4d4f75   2         2         2       8s

```

## Prerequisites

- Podman
- kind
- kubectl
- terraform

## Quick Start

### Start the cluster

```bash
./run.sh
```

This will:
- Create a kind cluster named "atlantis-cluster"
- Deploy Atlantis to the cluster
- Set up all necessary resources

### Access Atlantis UI

```bash
./ui.sh
```

Access Atlantis at: http://localhost:4141

### Apply Terraform using Atlantis

```bash
./apply-terraform.sh
```

This will:
- Copy your local terraform files to the Atlantis pod
- Run terraform init, plan, and apply inside Atlantis
- Show you the created resources

### Stop the cluster

```bash
./stop.sh
```

## Terraform Resources

The Terraform configuration deploys:
- A namespace called "terraform-app"
- A ConfigMap with application settings
- An nginx deployment with 2 replicas
- A ClusterIP service

## Using Atlantis

This setup allows you to run Terraform through the Atlantis pod without requiring an external GitHub repository.

The `apply-terraform.sh` script:
1. Copies your local terraform/ folder to the Atlantis pod
2. Executes terraform commands using Atlantis's built-in terraform binary
3. Applies changes directly to the kind cluster

This is perfect for local development and testing.

## Configuration

### Atlantis Configuration

The `atlantis.yaml` file defines the project structure and workflows.

### Kubernetes Manifests

All Kubernetes manifests are in the `specs/` directory and will be applied automatically when running `./run.sh`.

### Terraform Configuration

The Terraform configuration in the `terraform/` directory manages Kubernetes resources using the kubernetes provider.