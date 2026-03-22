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
