# Ministack Fun

Java 25 + Spring Boot 4.0.4 application that provisions and interacts with AWS services on [Ministack](https://ministack.org/) using OpenTofu and AWS SDK v2.

## AWS Services

| Service | Resource | Purpose |
|---------|----------|---------|
| STS | Caller Identity | Verifies AWS credentials and account info |
| SecretsManager | `ministack/app-config` | Stores application credentials |
| SQS | `ministack-app-queue` | Message queue with send and attribute inspection |
| S3 | `ministack-app-bucket` | Object storage with sample JSON data |
| Kinesis | `ministack-app-stream` | Stream with 1 shard for event processing |
| RDS | `ministack-app-db` | PostgreSQL 15.4 real database container |

## Prerequisites

- Java 25
- Maven
- OpenTofu
- Podman (`podman pull nahuelnucera/ministack`)
- Python 3

## Quick Start

```bash
./start-infra.sh
./run.sh
./test.sh
```

## Scripts

| Script | Description |
|--------|-------------|
| `start-infra.sh` | Starts Ministack container and provisions all AWS resources |
| `stop-infra.sh` | Destroys resources and stops Ministack container |
| `provision.sh` | Runs OpenTofu init and apply |
| `run.sh` | Builds and starts the Spring Boot app on port 8181 |
| `stop.sh` | Stops the Spring Boot app |
| `test.sh` | Calls `/status` endpoint showing all services |

## API

### GET /status

Returns JSON with real-time status of all 6 AWS services fetched from Ministack.

```json
{
  "sts": { "status": "OK", "account": "000000000000" },
  "secretsManager": { "status": "OK", "configName": "ministack/app-config" },
  "sqs": { "status": "OK", "queueUrl": "...", "messageId": "..." },
  "s3": { "status": "OK", "bucket": "ministack-app-bucket", "objectCount": 1 },
  "kinesis": { "status": "OK", "streamName": "ministack-app-stream", "shardCount": 1 },
  "rds": { "status": "OK", "instanceId": "ministack-app-db", "engine": "postgres" }
}
```

## Project Structure

```
ministack-fun/
  infra/
    main.tf                - OpenTofu definitions for all AWS services
  app/
    pom.xml                - Maven build with Spring Boot 4.0.4 + AWS SDK v2
    src/main/java/com/ministack/
      App.java             - Spring Boot entry point
      AwsConfig.java       - AWS SDK v2 client beans pointing to Ministack
      StatusController.java - /status endpoint querying all 6 services
  start-infra.sh           - Start Ministack container + provision
  stop-infra.sh            - Destroy + stop Ministack container
  provision.sh             - OpenTofu apply
  run.sh                   - Build and run Java app
  stop.sh                  - Stop Java app
  test.sh                  - Test /status endpoint
```

## Tech Stack

- **Java 25** with **Spring Boot 4.0.4**
- **AWS SDK v2** (2.31.57) for SecretsManager, SQS, S3, STS, Kinesis, RDS
- **OpenTofu** for infrastructure provisioning
- **Ministack** as local AWS cloud emulator (container-based)
- **Podman** for running the Ministack container

## OpenTofu (Terraform) 

```
./start-infra.sh
```
```
❯ ./start-infra.sh
ministack
ministack
f150654bb4090273c2a097c07bcd0434493a659532494aff17ec9fd3d1d5aeaa
Ministack is ready

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.100.0...
- Installed hashicorp/aws v5.100.0 (signed, key ID 0C0AF313E5FD9F80)

Providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://opentofu.org/docs/cli/plugins/signing/

OpenTofu has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that OpenTofu can guarantee to make the same selections by default when
you run "tofu init" in the future.

OpenTofu has been successfully initialized!

You may now begin working with OpenTofu. Try running "tofu plan" to see
any changes that are required for your infrastructure. All OpenTofu commands
should now work.

If you ever set or change modules or backend configuration for OpenTofu,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions:

  # aws_db_instance.app_db will be created
  + resource "aws_db_instance" "app_db" {
      + address                               = (known after apply)
      + allocated_storage                     = 20
      + apply_immediately                     = false
      + arn                                   = (known after apply)
      + auto_minor_version_upgrade            = true
      + availability_zone                     = (known after apply)
      + backup_retention_period               = (known after apply)
      + backup_target                         = (known after apply)
      + backup_window                         = (known after apply)
      + ca_cert_identifier                    = (known after apply)
      + character_set_name                    = (known after apply)
      + copy_tags_to_snapshot                 = false
      + database_insights_mode                = (known after apply)
      + db_name                               = "appdb"
      + db_subnet_group_name                  = (known after apply)
      + dedicated_log_volume                  = false
      + delete_automated_backups              = true
      + domain_fqdn                           = (known after apply)
      + endpoint                              = (known after apply)
      + engine                                = "postgres"
      + engine_lifecycle_support              = (known after apply)
      + engine_version                        = "15.4"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "ministack-app-db"
      + identifier_prefix                     = (known after apply)
      + instance_class                        = "db.t3.micro"
      + iops                                  = (known after apply)
      + kms_key_id                            = (known after apply)
      + latest_restorable_time                = (known after apply)
      + license_model                         = (known after apply)
      + listener_endpoint                     = (known after apply)
      + maintenance_window                    = (known after apply)
      + master_user_secret                    = (known after apply)
      + master_user_secret_kms_key_id         = (known after apply)
      + monitoring_interval                   = 0
      + monitoring_role_arn                   = (known after apply)
      + multi_az                              = (known after apply)
      + nchar_character_set_name              = (known after apply)
      + network_type                          = (known after apply)
      + option_group_name                     = (known after apply)
      + parameter_group_name                  = (known after apply)
      + password                              = (sensitive value)
      + password_wo                           = (write-only attribute)
      + performance_insights_enabled          = false
      + performance_insights_kms_key_id       = (known after apply)
      + performance_insights_retention_period = (known after apply)
      + port                                  = (known after apply)
      + publicly_accessible                   = false
      + replica_mode                          = (known after apply)
      + replicas                              = (known after apply)
      + resource_id                           = (known after apply)
      + skip_final_snapshot                   = true
      + snapshot_identifier                   = (known after apply)
      + status                                = (known after apply)
      + storage_throughput                    = (known after apply)
      + storage_type                          = (known after apply)
      + tags_all                              = (known after apply)
      + timezone                              = (known after apply)
      + username                              = "dbadmin"
      + vpc_security_group_ids                = (known after apply)
    }

  # aws_kinesis_stream.app_stream will be created
  + resource "aws_kinesis_stream" "app_stream" {
      + arn                       = (known after apply)
      + encryption_type           = "NONE"
      + enforce_consumer_deletion = false
      + id                        = (known after apply)
      + name                      = "ministack-app-stream"
      + retention_period          = 48
      + shard_count               = 1
      + tags_all                  = (known after apply)

      + stream_mode_details (known after apply)
    }

  # aws_s3_bucket.app_bucket will be created
  + resource "aws_s3_bucket" "app_bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = "ministack-app-bucket"
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # aws_s3_object.sample_data will be created
  + resource "aws_s3_object" "sample_data" {
      + acl                    = (known after apply)
      + arn                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_crc64nvme     = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content                = jsonencode(
            {
              + items   = [
                  + "alpha",
                  + "bravo",
                  + "charlie",
                ]
              + message = "Hello from Ministack S3"
              + version = "1.0.0"
            }
        )
      + content_type           = (known after apply)
      + etag                   = (known after apply)
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "data/sample.json"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + storage_class          = (known after apply)
      + tags_all               = (known after apply)
      + version_id             = (known after apply)
    }

  # aws_secretsmanager_secret.app_config will be created
  + resource "aws_secretsmanager_secret" "app_config" {
      + arn                            = (known after apply)
      + force_overwrite_replica_secret = false
      + id                             = (known after apply)
      + name                           = "ministack/app-config"
      + name_prefix                    = (known after apply)
      + policy                         = (known after apply)
      + recovery_window_in_days        = 30
      + tags_all                       = (known after apply)

      + replica (known after apply)
    }

  # aws_secretsmanager_secret_version.app_config_value will be created
  + resource "aws_secretsmanager_secret_version" "app_config_value" {
      + arn                  = (known after apply)
      + has_secret_string_wo = (known after apply)
      + id                   = (known after apply)
      + secret_id            = (known after apply)
      + secret_string        = (sensitive value)
      + secret_string_wo     = (write-only attribute)
      + version_id           = (known after apply)
      + version_stages       = (known after apply)
    }

  # aws_sqs_queue.app_queue will be created
  + resource "aws_sqs_queue" "app_queue" {
      + arn                               = (known after apply)
      + content_based_deduplication       = false
      + deduplication_scope               = (known after apply)
      + delay_seconds                     = 0
      + fifo_queue                        = false
      + fifo_throughput_limit             = (known after apply)
      + id                                = (known after apply)
      + kms_data_key_reuse_period_seconds = (known after apply)
      + max_message_size                  = 262144
      + message_retention_seconds         = 345600
      + name                              = "ministack-app-queue"
      + name_prefix                       = (known after apply)
      + policy                            = (known after apply)
      + receive_wait_time_seconds         = 0
      + redrive_allow_policy              = (known after apply)
      + redrive_policy                    = (known after apply)
      + sqs_managed_sse_enabled           = (known after apply)
      + tags_all                          = (known after apply)
      + url                               = (known after apply)
      + visibility_timeout_seconds        = 30
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bucket_name         = (known after apply)
  + kinesis_stream_name = "ministack-app-stream"
  + queue_url           = (known after apply)
  + rds_endpoint        = (known after apply)
  + secret_arn          = (known after apply)
aws_secretsmanager_secret.app_config: Creating...
aws_sqs_queue.app_queue: Creating...
aws_s3_bucket.app_bucket: Creating...
aws_db_instance.app_db: Creating...
aws_kinesis_stream.app_stream: Creating...
aws_secretsmanager_secret.app_config: Creation complete after 0s [id=arn:aws:secretsmanager:us-east-1:000000000000:secret:ministack/app-config-8b9670]
aws_secretsmanager_secret_version.app_config_value: Creating...
aws_secretsmanager_secret_version.app_config_value: Creation complete after 0s [id=arn:aws:secretsmanager:us-east-1:000000000000:secret:ministack/app-config-8b9670|terraform-20260401184243212900000002]
aws_s3_bucket.app_bucket: Creation complete after 0s [id=ministack-app-bucket]
aws_s3_object.sample_data: Creating...
aws_s3_object.sample_data: Creation complete after 0s [id=data/sample.json]
aws_sqs_queue.app_queue: Still creating... [10s elapsed]
aws_db_instance.app_db: Still creating... [10s elapsed]
aws_kinesis_stream.app_stream: Still creating... [10s elapsed]
aws_sqs_queue.app_queue: Still creating... [20s elapsed]
aws_db_instance.app_db: Still creating... [20s elapsed]
aws_kinesis_stream.app_stream: Still creating... [20s elapsed]
aws_kinesis_stream.app_stream: Creation complete after 20s [id=arn:aws:kinesis:us-east-1:000000000000:stream/ministack-app-stream]
aws_sqs_queue.app_queue: Creation complete after 25s [id=http://localhost:4566/000000000000/ministack-app-queue]
aws_db_instance.app_db: Still creating... [30s elapsed]
aws_db_instance.app_db: Still creating... [40s elapsed]
aws_db_instance.app_db: Still creating... [50s elapsed]
aws_db_instance.app_db: Still creating... [1m0s elapsed]
aws_db_instance.app_db: Still creating... [1m10s elapsed]
aws_db_instance.app_db: Still creating... [1m20s elapsed]
aws_db_instance.app_db: Creation complete after 1m20s [id=db-A766029315FB4869AF6E]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

bucket_name = "ministack-app-bucket"
kinesis_stream_name = "ministack-app-stream"
queue_url = "http://localhost:4566/000000000000/ministack-app-queue"
rds_endpoint = "localhost:5432"
secret_arn = "arn:aws:secretsmanager:us-east-1:000000000000:secret:ministack/app-config-8b9670"
```

## Spring Boot app

```
❯ ./run.sh
App starting on http://localhost:8181

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v4.0.4)

2026-04-01T12:29:49.021-07:00  INFO 64774 --- [           main] com.ministack.App                        : Starting App v1.0.0 using Java 25.0.2 with PID 64774 (/Users/diegopacheco/git/diegopacheco/devops-playground/ministack-fun/app/target/ministack-app-1.0.0.jar started by diegopacheco in /Users/diegopacheco/git/diegopacheco/devops-playground/ministack-fun/app)
2026-04-01T12:29:49.024-07:00  INFO 64774 --- [           main] com.ministack.App                        : No active profile set, falling back to 1 default profile: "default"
2026-04-01T12:29:49.318-07:00  INFO 64774 --- [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat initialized with port 8181 (http)
2026-04-01T12:29:49.323-07:00  INFO 64774 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2026-04-01T12:29:49.323-07:00  INFO 64774 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/11.0.18]
2026-04-01T12:29:49.332-07:00  INFO 64774 --- [           main] b.w.c.s.WebApplicationContextInitializer : Root WebApplicationContext: initialization completed in 288 ms
2026-04-01T12:29:49.811-07:00  INFO 64774 --- [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat started on port 8181 (http) with context path '/'
2026-04-01T12:29:49.816-07:00  INFO 64774 --- [           main] com.ministack.App                        : Started App in 0.94 seconds (process running for 1.116)
2026-04-01T12:29:50.753-07:00  INFO 64774 --- [nio-8181-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2026-04-01T12:29:50.753-07:00  INFO 64774 --- [nio-8181-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2026-04-01T12:29:50.754-07:00  INFO 64774 --- [nio-8181-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
App is ready
```

## Testing resources

```
❯ ./test.sh
Testing /status endpoint...

{
    "sts": {
        "status": "OK",
        "account": "000000000000",
        "arn": "arn:aws:iam::000000000000:root",
        "userId": "000000000000"
    },
    "secretsManager": {
        "status": "OK",
        "configName": "ministack/app-config",
        "configValue": "{\"api_key\":\"mk-abc123def456\",\"password\":\"supersecret123\",\"username\":\"admin\"}"
    },
    "sqs": {
        "status": "OK",
        "queueUrl": "http://localhost:4566/000000000000/ministack-app-queue",
        "messageId": "45fe5d0e-5f23-41e4-be5d-f3412b0927c9",
        "approximateMessages": "6"
    },
    "s3": {
        "status": "OK",
        "bucket": "ministack-app-bucket",
        "objectCount": 1,
        "keys": [
            "data/sample.json"
        ],
        "sampleContent": "{\"items\":[\"alpha\",\"bravo\",\"charlie\"],\"message\":\"Hello from Ministack S3\",\"version\":\"1.0.0\"}"
    },
    "kinesis": {
        "status": "OK",
        "streamName": "ministack-app-stream",
        "streamStatus": "ACTIVE",
        "shardCount": 1,
        "putRecordSequence": "000000017750718815530000000007"
    },
    "rds": {
        "status": "OK",
        "instanceCount": 1,
        "instanceId": "ministack-app-db",
        "engine": "postgres",
        "dbName": "appdb",
        "instanceStatus": "available",
        "endpoint": "localhost:5432"
    }
}

All services checked.
```