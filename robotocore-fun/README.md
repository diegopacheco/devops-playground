# robotocore-fun

POC using [robotocore](https://github.com/robotocore/robotocore) - a digital twin of AWS that runs locally in a single container.

This project uses Java 25 with AWS SDK v2 to interact with AWS services running locally via robotocore. All infrastructure is provisioned using OpenTofu.

## AWS Services Used

* **S3** - Object storage (put/get objects)
* **SQS** - Message queue (send/receive messages)
* **SNS** - Pub/Sub notifications (publish messages)
* **Lambda** - Serverless functions (invoke Python function)
* **OpenSearch** - Search and analytics (describe domain)
* **Secrets Manager** - Secret storage (read secrets)

## Prerequisites

* Java 25
* Maven 3.9+
* Podman and podman-compose
* OpenTofu (tofu)
* AWS CLI v2

## How to Run

### 1. Start robotocore
```bash
./start.sh
```

### 2. Create infrastructure with OpenTofu
```bash
./create-infra.sh
```

### 3. Run the Java application
```bash
./run.sh
```

### 4. Test everything
```bash
./test.sh
```

### 5. Stop robotocore
```bash
./stop.sh
```

## Project Structure

```
.
├── podman-compose.yml      # robotocore container definition
├── start.sh                # Start robotocore
├── stop.sh                 # Stop robotocore
├── test.sh                 # Verify all services
├── create-infra.sh         # Apply OpenTofu infrastructure
├── run.sh                  # Build and run Java app
├── infra/                  # OpenTofu definitions
│   ├── providers.tf        # AWS provider pointing to robotocore
│   ├── s3.tf               # S3 bucket
│   ├── sqs.tf              # SQS queue
│   ├── sns.tf              # SNS topic
│   ├── lambda.tf           # Lambda function + IAM role
│   ├── opensearch.tf       # OpenSearch domain
│   ├── sm.tf               # Secrets Manager secret
│   └── outputs.tf          # Terraform outputs
├── lambda/                 # Lambda function source
│   └── index.py            # Python handler
├── pom.xml                 # Maven project (Java 25 + AWS SDK v2)
└── src/main/java/com/robotocore/
    └── Main.java           # Java app testing all 6 services
```

## Output

```
=== Robotocore Java 25 POC ===

--- S3 ---
Buckets: [my-data-bucket]
PUT object: hello.txt
GET object: Hello from Java 25!
PASS

--- SQS ---
Queue URL: http://sqs.us-east-1.localhost.robotocore.cloud:4566/123456789012/my-queue
Sent message to queue
Received: Hello from Java 25 via SQS!
PASS

--- SNS ---
Topic ARN: arn:aws:sns:us-east-1:123456789012:my-topic
Published message ID: 25c368fe-bb55-40c8-8edb-92652838db6c
PASS

--- Lambda ---
Lambda response: {"statusCode": 200, "body": "Hello from robotocore Lambda!"}
PASS

--- OpenSearch ---
Domain: my-search-domain
Engine: OpenSearch_2.11
Endpoint: my-search-domain.us-east-1.es.amazonaws.com
PASS

--- Secrets Manager ---
Secret name: my-secret
Secret value: {"password":"change-me","username":"admin"}
PASS

=== Results: 6 passed, 0 failed ===
```
