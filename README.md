# devops-playground

Hands-on POCs of DevOps, cloud and platform engineering. Every folder is one small project you can run locally.

## ☸️ Kubernetes

Kubernetes runs containers across many machines and keeps them in the state you asked for.
Most projects here run on a local kind or minikube cluster.

* [k8s-concepts](k8s-concepts/) - How Kubernetes handles CPU requests and limits
* [k8s-configmaps-properties](k8s-configmaps-properties/) - ConfigMaps mounted as properties files on kind
* [k8s-kind-helm](k8s-kind-helm/) - Java app packaged as a Helm chart and deployed on kind
* [k8s-pod-hostname](k8s-pod-hostname/) - App that prints the pod hostname it runs on
* [k8s-simple-controller](k8s-simple-controller/) - Custom Kubernetes controller written in Go
* [k8s-simple-crd-custom](k8s-simple-crd-custom/) - Custom Resource Definition on kind
* [kubernetes](kubernetes/) - InfluxDB stack, monitoring, DNS, port-forward and a Redis Go app
* [kubernetes-minikube-docker-boot](kubernetes-minikube-docker-boot/) - Java app baked into Docker and run on minikube
* [minikube](minikube/) - minikube with ConfigMaps, Ingress and a multi-tier app
* [mychart](mychart/) - A minimal Helm chart
* [cdk8s-fun](cdk8s-fun/) - cdk8s in JavaScript deploying nginx to kind
* [arkade-kind-fun](arkade-kind-fun/) - arkade installing Kubernetes CLIs and apps on kind
* [headlamp-k8s-ui](headlamp-k8s-ui/) - Headlamp web UI for a kind cluster
* [metallb](metallb/) - MetalLB giving LoadBalancer IPs to services on kind
* [knative-kind-fun](knative-kind-fun/) - Knative serverless services on kind
* [keda-autoscaling-fun](keda-autoscaling-fun/) - KEDA scaling a Rust service under k6 load
* [volcano-fun](volcano-fun/) - Volcano batch scheduler running a Flink job
* [k8ssandra](k8ssandra/) - Cassandra on Kubernetes with K8ssandra, Prometheus, Grafana and Reaper

## 🕸️ Service Mesh & Proxies

Proxies sit in front of services and handle routing, retries and TLS.
A service mesh puts one proxy next to every service and controls them all from one place.

* [istio-1.22.3-local](istio-1.22.3-local/) - Istio 1.22.3 on a local cluster with its dashboards
* [kuma-kind-k8s](kuma-kind-k8s/) - Kuma service mesh on kind
* [envoy-proxy-rust-svc](envoy-proxy-rust-svc/) - Rust service behind a front Envoy and a service Envoy
* [traefik](traefik/) - Traefik reverse proxy with docker-compose
* [traefik-fun](traefik-fun/) - Traefik configured from a TOML file

## 🚀 CI/CD, GitOps & Build

Pipelines build, test and ship code on every change.
GitOps keeps the cluster in sync with what is in git.

* [argocd-k8s-canary](argocd-k8s-canary/) - Argo CD with canary progressive delivery on kind
* [argodc-kind](argodc-kind/) - Argo CD installed on kind
* [atlantis-terraform-fun](atlantis-terraform-fun/) - Atlantis running Terraform plans and applies on kind
* [Jenkins-DSL-scripts](Jenkins-DSL-scripts/) - Jenkins Job DSL to build and release Apache
* [jenkis-dsl-seed](jenkis-dsl-seed/) - Jenkins Job DSL seed job
* [Jenkinsfile-groovy-spock-test](Jenkinsfile-groovy-spock-test/) - Jenkinsfile tested with Groovy and Spock
* [bazelisk-bazel](bazelisk-bazel/) - Bazel builds through Bazelisk
* [buildkit-fun](buildkit-fun/) - BuildKit building container images without a Docker daemon
* [gradle-nebula](gradle-nebula/) - Gradle with Netflix Nebula plugins
* [prek-fun](prek-fun/) - prek: pre-commit hooks written in Rust

## 🛡️ Policy & Kubernetes Testing

Policies block bad manifests before they reach the cluster.
Test tools check that what is running matches what you expect.

* [kyverno-policy-fun](kyverno-policy-fun/) - Kyverno admission policies on kind
* [opa-policy-fun](opa-policy-fun/) - Open Policy Agent rules for Kubernetes
* [conftest-fun](conftest-fun/) - Conftest checking Kubernetes YAML and Terraform with Rego
* [polaris-validation-fun](polaris-validation-fun/) - Fairwinds Polaris best-practice checks with its UI
* [kube-conform-fun](kube-conform-fun/) - kubeconform validating manifests against schemas
* [kube-assert-fun](kube-assert-fun/) - kubectl-assert checks on live cluster state
* [kuttl-fun](kuttl-fun/) - KUTTL declarative end-to-end tests for Kubernetes

## 🔐 Security

Scanners find known CVEs in images and misconfigurations in code.
Runtime tools watch what containers actually do while they run.

* [trivy-vulnerabilities-checker](trivy-vulnerabilities-checker/) - Trivy scanning container images for CVEs
* [docker-registry-trivy-k8s--registry-fun](docker-registry-trivy-k8s--registry-fun/) - Local image registry with Trivy scans
* [falco-runtime-security](falco-runtime-security/) - Falco runtime security alerts on Kubernetes
* [vault-secrets-k8s](vault-secrets-k8s/) - HashiCorp Vault serving secrets to a Go app on kind
* [checkov-fun](checkov-fun/) - Checkov scanning Terraform for misconfigurations
* [terrascan-fun](terrascan-fun/) - Terrascan scanning Terraform
* [tfsec-fun](tfsec-fun/) - tfsec scanning Terraform
* [sec-threagile](sec-threagile/) - Threagile threat model with risk report and diagrams

## 🏗️ Infrastructure as Code

Infrastructure is described in files, reviewed like code and applied by a tool.
Most projects here use Terraform, a few use CloudFormation and Pulumi.

* [terraform](terraform/) - Terraform basics with variables and outputs
* [terraform-foreach-fun](terraform-foreach-fun/) - for_each over data loaded from JSON
* [terraform-functions](terraform-functions/) - Terraform built-in functions
* [terraform-functions-diffs-lists](terraform-functions-diffs-lists/) - Diffing lists with Terraform functions
* [terraform-local-exec-fun](terraform-local-exec-fun/) - local-exec provisioner
* [terraform-module-fun](terraform-module-fun/) - A small reusable Terraform module
* [terraform-templatefile](terraform-templatefile/) - templatefile rendering backend configs
* [terraform-var-from-bash](terraform-var-from-bash/) - Terraform variables fed from a bash script
* [terraform-roles](terraform-roles/) - IAM roles with Terraform
* [terraform-native-roles](terraform-native-roles/) - IAM roles with native Terraform resources
* [terraform-elasticache-redis](terraform-elasticache-redis/) - ElastiCache Redis with Terraform
* [terraform-13-elasticache-redis6](terraform-13-elasticache-redis6/) - ElastiCache Redis 6 with Terraform 0.13
* [terraform-localstack-policy-source](terraform-localstack-policy-source/) - IAM policy documents applied on LocalStack
* [terraform-localstack-s3-object](terraform-localstack-s3-object/) - S3 objects created on LocalStack
* [tf2-tests](tf2-tests/) - Unit tests for a Terraform plan in Python
* [tf2-tests-e2e](tf2-tests-e2e/) - End-to-end tests for applied Terraform in Python
* [clarify_fun](clarify_fun/) - BDD feature files testing Terraform
* [tflint-fun](tflint-fun/) - TFLint linting Terraform
* [cloud-formation](cloud-formation/) - CloudFormation stack for an EC2 instance
* [pulumi-kubernetes-python](pulumi-kubernetes-python/) - Pulumi in Python deploying to Kubernetes

## ☁️ Local AWS

AWS emulators run S3, SQS, IAM and friends on your laptop.
You test cloud code without an account and without a bill.

* [localstack-sqs](localstack-sqs/) - SQS queues on LocalStack
* [kinises_fun](kinises_fun/) - Kinesis streams created, written and read from the CLI
* [ministack-fun](ministack-fun/) - Java 25 + Spring Boot on Ministack, provisioned with OpenTofu
* [robotocore-fun](robotocore-fun/) - robotocore: a local AWS twin in one container, with Java 25 and Lambda
* [aws-floci-athena-playground](aws-floci-athena-playground/) - Athena and Glue on Floci with a SQL playground UI
* [aws-floci-iam-lab](aws-floci-iam-lab/) - IAM lab on Floci: users, roles, policies and access checks

## 🐳 Containers

Containers package an app with everything it needs to run.
Here: Dockerfiles, compose, multi-stage builds and other runtimes.

* [docker-build](docker-build/) - Build and run an image
* [docker-build-multi-stage](docker-build-multi-stage/) - Multi-stage builds for C and Go
* [docker-compose](docker-compose/) - Python app with docker-compose
* [docker-nodesjs-app](docker-nodesjs-app/) - Node.js app in Docker
* [docker-ubuntu](docker-ubuntu/) - Ubuntu base image
* [docker-ssh](docker-ssh/) - Container with an SSH server
* [docker-eureka](docker-eureka/) - Netflix Eureka in Docker
* [docker-dynomite](docker-dynomite/) - Netflix Dynomite with Redis in Docker
* [dockerfiles](dockerfiles/) - Java 8 base Dockerfile
* [docker-in-docker](docker-in-docker/) - Running Docker inside Docker
* [docker-machine](docker-machine/) - Docker Machine on AWS and VirtualBox
* [podman-docker-compose-simple](podman-docker-compose-simple/) - Compose files running on podman-compose
* [colima-docker](colima-docker/) - Colima as a Docker runtime on macOS
* [apple-macos-container-machine-poc](apple-macos-container-machine-poc/) - Apple container running Redis 8 in a Linux machine on macOS

## 📦 Vagrant & VMs

Vagrant creates reproducible virtual machines from one file.
Each VM here is provisioned with a stack ready to use.

* [vagrant](vagrant/) - Vagrant basics
* [vagrant-multi-project](vagrant-multi-project/) - Several VMs in one Vagrantfile
* [vagrant-docker](vagrant-docker/) - VM with Docker
* [vagrant-docker-provision](vagrant-docker-provision/) - VM provisioned with the Docker provisioner
* [vagrant-with-docker](vagrant-with-docker/) - VM with Docker and a shared folder
* [vagrant-with-nodejs](vagrant-with-nodejs/) - VM with Node.js
* [vagrant-jvm](vagrant-jvm/) - VM with the JVM
* [vagrant-python](vagrant-python/) - VM with Python for ML
* [vagrant-ruby](vagrant-ruby/) - VM with Ruby
* [vagrant-mysql](vagrant-mysql/) - VM with MySQL
* [vagrant-postgress](vagrant-postgress/) - VM with PostgreSQL
* [vagrant-with-rabbitmq](vagrant-with-rabbitmq/) - VM with RabbitMQ
* [vagrant-apache-spark](vagrant-apache-spark/) - VM with Apache Spark
* [vagrant-apache-storm](vagrant-apache-storm/) - VM with Apache Storm
* [vagrant-apache-samza](vagrant-apache-samza/) - VM with Apache Samza
* [vagrant-ansible](vagrant-ansible/) - VM provisioned with Ansible playbooks
* [vagrant-puppet](vagrant-puppet/) - VM provisioned with Puppet
* [vagrant-puppet-provision](vagrant-puppet-provision/) - Puppet manifests serving a web page
* [vagrant-puppet-slave](vagrant-puppet-slave/) - Puppet agent VM
* [vagrant-sensu](vagrant-sensu/) - Sensu monitoring server and client
* [vagrant-telemetry](vagrant-telemetry/) - collectd, Logstash and Elasticsearch telemetry stack
* [vagrant-spinnaker](vagrant-spinnaker/) - VM with Spinnaker
* [vagrant-StackStorm](vagrant-StackStorm/) - VM with StackStorm

## 🧑‍🍳 Configuration Management & Images

Config management tools install and configure software on servers the same way every time.
Image builders bake that setup into a machine image ahead of time.

* [ansible_aws](ansible_aws/) - Ansible with an EC2 dynamic inventory
* [chef](chef/) - Chef recipes for a web server
* [test-kitchen](test-kitchen/) - Test Kitchen for Chef
* [habitat-example-plans](habitat-example-plans/) - Chef Habitat plans from the Habitat tutorials
* [packer_aws](packer_aws/) - Packer building an AWS AMI
* [packer-ansible](packer-ansible/) - Packer provisioning Apache with Ansible
* [otto-fun](otto-fun/) - HashiCorp Otto with a Ruby app

## 📈 Observability

Metrics, logs and traces show what a system is doing and why it is slow.
Dashboards and alerts turn them into something you can act on.

* [prometheus](prometheus/) - Prometheus with alert rules and a webhook receiver
* [promtol-test-fun](promtol-test-fun/) - Unit tests for Prometheus alert rules with promtool
* [grafana-prometheus](grafana-prometheus/) - Prometheus, node-exporter, cAdvisor and Grafana dashboards
* [grafana-dashboard-tests](grafana-dashboard-tests/) - Automated tests for Grafana dashboards
* [Grafana](Grafana/) - Grafana dashboards for Elasticsearch, Graphite and InfluxDB
* [loki](loki/) - Grafana Loki and Promtail for logs
* [open-telemetry-fun](open-telemetry-fun/) - OpenTelemetry Collector with a Java app
* [sentry-fun-poc](sentry-fun-poc/) - Self-hosted Sentry on podman with a Rust app sending errors
* [monitoror-fun](monitoror-fun/) - Monitoror wallboard config

## 💥 Chaos & Load Testing

Chaos tools break things on purpose to see if the system survives.
Load tools push traffic until something gives.

* [docker-chaos-pumba](docker-chaos-pumba/) - Pumba killing and slowing Docker containers
* [litmus-chaos-k8s](litmus-chaos-k8s/) - LitmusChaos experiments on Kubernetes
* [k6-fun](k6-fun/) - Stress tests with k6
* [taurus](taurus/) - Load tests with Taurus

## 🗄️ Databases & Data

Databases, query engines and data tools run the way ops teams see them.
Partitioning, migrations, anonymization and SQL regression tests.

* [sql-playground](sql-playground/) - MySQL SQL playground in Docker
* [mysql-partition](mysql-partition/) - MySQL RANGE, LIST, HASH and KEY partitioning
* [postgres-partitions-playground](postgres-partitions-playground/) - PostgreSQL 17 partitioning strategies with benchmarks
* [postgresql-anonymizer](postgresql-anonymizer/) - PostgreSQL Anonymizer masking personal data
* [regresql-test-regression-sql-fun](regresql-test-regression-sql-fun/) - RegreSQL regression tests for SQL queries
* [liquibase-mysql-docker](liquibase-mysql-docker/) - Liquibase migrations on MySQL
* [tin-postgres-fun](tin-postgres-fun/) - PlanetScale TIN full-text search on Postgres 18 with a Go API and UI
* [clickhouse-fun](clickhouse-fun/) - ClickHouse service metrics with a Go backend and Next.js dashboard
* [druid-fun](druid-fun/) - Apache Druid 31 running locally
* [presto-fun](presto-fun/) - Presto with a Python client
* [trino-fun](trino-fun/) - Trino queries from the CLI and Python
* [apache-sedona-fun](apache-sedona-fun/) - Flink 1.19 with Apache Sedona geospatial on kind
* [dolt-git-for-data-fun](dolt-git-for-data-fun/) - Dolt: a SQL database with git branches and commits
* [limbo](limbo/) - Limbo, SQLite rewritten in Rust
* [netflixoss-dynomite](netflixoss-dynomite/) - Netflix Dynomite with Redis across three racks
* [Marquez-lineage-fun](Marquez-lineage-fun/) - Marquez lineage for Airflow DAGs

## 📨 Messaging

Brokers move messages between services so they do not call each other directly.

* [iggy-poc](iggy-poc/) - Apache Iggy on podman with a Rust producer and consumer
* [kplay-kafka-fun](kplay-kafka-fun/) - kplay TUI browsing Kafka topics
* [kroxylicious-kafka](kroxylicious-kafka/) - Kroxylicious Kafka proxy encrypting messages with KMS

## 🐧 Linux & Shell

The layer under every container and VM.
Init systems, kernel limits and scripts you reach for when a box misbehaves.

* [linux-scripts](linux-scripts/) - Check keepalive, limits, TCP backlog and active connections
* [linux-init-scripts](linux-init-scripts/) - init.d scripts for Cassandra, Dynomite, Redis and Tomcat
* [systemd](systemd/) - systemd service for a crashing C app with core dumps
* [upstart](upstart/) - Upstart service for a crashing C app with core dumps
* [shell](shell/) - Bash tests with bats

## 🧰 Developer Platforms & Tools

Tools that make the day to day of engineering teams easier.

* [backstage-fun](backstage-fun/) - Backstage portal with catalog, APIs, docs, tech radar and cost on kind
* [sheets-fun](sheets-fun/) - sheets: a spreadsheet in the terminal
