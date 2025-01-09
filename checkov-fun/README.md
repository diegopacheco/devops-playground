### Installl

```bash
brew install checkov
```

### Run and Results

```bash
checkov --directory . --file main.tf
```

```
❯ checkov --directory . --file main.tf
[ terraform framework ]: 100%|████████████████████|[1/1], Current File Scanned=main.tf
[ secrets framework ]: 100%|████████████████████|[2/2], Current File Scanned=./main.tf

       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.2.350

terraform scan results:

Passed checks: 7, Failed checks: 12, Skipped checks: 0

Check: CKV_AWS_41: "Ensure no hard coded AWS access key and secret key exists in provider"
        PASSED for resource: aws.default
        File: /main.tf:1-5
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/secrets-policies/bc-aws-secrets-5
Check: CKV_AWS_382: "Ensure no security groups allow egress from 0.0.0.0:0 to port -1"
        PASSED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
Check: CKV_AWS_277: "Ensure no security groups allow ingress from 0.0.0.0:0 to port -1"
        PASSED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/ensure-aws-security-group-does-not-allow-all-traffic-on-all-ports
Check: CKV_AWS_23: "Ensure every security group and rule has a description"
        PASSED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/networking-31
Check: CKV_AWS_93: "Ensure S3 bucket policy does not lockout all but root user. (Prevent lockouts needing root account fixes)"
        PASSED for resource: aws_s3_bucket.public_bucket
        File: /main.tf:28-31
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-24
Check: CKV_AWS_133: "Ensure that RDS instances has backup policy"
        PASSED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-that-rds-instances-have-backup-policy
Check: CKV_AWS_211: "Ensure RDS uses a modern CaCert"
        PASSED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-aws-rds-uses-a-modern-cacert
Check: CKV_AWS_24: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 22"
        FAILED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/networking-1-port-security

                7  | resource "aws_security_group" "open_sg" {
                8  |   name        = "open_sg"
                9  |   description = "Security Group with all ports open"
                10 |
                11 |   ingress {
                12 |     description      = "Allow all inbound traffic"
                13 |     from_port        = 0
                14 |     to_port          = 65535
                15 |     protocol         = "tcp"
                16 |     cidr_blocks      = ["0.0.0.0/0"]
                17 |   }
                18 |
                19 |   egress {
                20 |     description = "Allow all outbound traffic"
                21 |     from_port   = 0
                22 |     to_port     = 65535
                23 |     protocol    = "tcp"
                24 |     cidr_blocks = ["0.0.0.0/0"]
                25 |   }
                26 | }

Check: CKV_AWS_25: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389"
        FAILED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/networking-2

                7  | resource "aws_security_group" "open_sg" {
                8  |   name        = "open_sg"
                9  |   description = "Security Group with all ports open"
                10 |
                11 |   ingress {
                12 |     description      = "Allow all inbound traffic"
                13 |     from_port        = 0
                14 |     to_port          = 65535
                15 |     protocol         = "tcp"
                16 |     cidr_blocks      = ["0.0.0.0/0"]
                17 |   }
                18 |
                19 |   egress {
                20 |     description = "Allow all outbound traffic"
                21 |     from_port   = 0
                22 |     to_port     = 65535
                23 |     protocol    = "tcp"
                24 |     cidr_blocks = ["0.0.0.0/0"]
                25 |   }
                26 | }

Check: CKV_AWS_260: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 80"
        FAILED for resource: aws_security_group.open_sg
        File: /main.tf:7-26
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/ensure-aws-security-groups-do-not-allow-ingress-from-00000-to-port-80

                7  | resource "aws_security_group" "open_sg" {
                8  |   name        = "open_sg"
                9  |   description = "Security Group with all ports open"
                10 |
                11 |   ingress {
                12 |     description      = "Allow all inbound traffic"
                13 |     from_port        = 0
                14 |     to_port          = 65535
                15 |     protocol         = "tcp"
                16 |     cidr_blocks      = ["0.0.0.0/0"]
                17 |   }
                18 |
                19 |   egress {
                20 |     description = "Allow all outbound traffic"
                21 |     from_port   = 0
                22 |     to_port     = 65535
                23 |     protocol    = "tcp"
                24 |     cidr_blocks = ["0.0.0.0/0"]
                25 |   }
                26 | }

Check: CKV_AWS_129: "Ensure that respective logs of Amazon Relational Database Service (Amazon RDS) are enabled"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-that-respective-logs-of-amazon-relational-database-service-amazon-rds-are-enabled

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_293: "Ensure that AWS database instances have deletion protection enabled"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-293

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_226: "Ensure DB instance gets all minor upgrades automatically"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-aws-db-instance-gets-all-minor-upgrades-automatically

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_161: "Ensure RDS database has IAM authentication enabled"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-rds-database-has-iam-authentication-enabled

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_157: "Ensure that RDS instances have Multi-AZ enabled"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/general-73

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_118: "Ensure that enhanced monitoring is enabled for Amazon RDS instances"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-logging-policies/ensure-that-enhanced-monitoring-is-enabled-for-amazon-rds-instances

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_16: "Ensure all data stored in the RDS is securely encrypted at rest"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/general-4

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_354: "Ensure RDS Performance Insights are encrypted using KMS CMKs"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-354

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
Check: CKV_AWS_17: "Ensure all data stored in RDS is not publicly accessible"
        FAILED for resource: aws_db_instance.unsecured_db
        File: /main.tf:33-45
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/public-policies/public-2

                33 | resource "aws_db_instance" "unsecured_db" {
                34 |   engine               = "mysql"
                35 |   instance_class       = "db.t2.micro"
                36 |   identifier           = "unsecured-db"
                37 |   username             = "admin"
                38 |   password             = "plaintextpassword"
                39 |   skip_final_snapshot  = true
                40 |   publicly_accessible  = true
                41 |   storage_encrypted    = false
                42 |   vpc_security_group_ids = [
                43 |     aws_security_group.open_sg.id
                44 |   ]
                45 | }
secrets scan results:

Passed checks: 0, Failed checks: 2, Skipped checks: 0

Check: CKV_SECRET_6: "Base64 High Entropy String"
        FAILED for resource: 0f082c72cae3563143745977406f69078807a203
        File: /main.tf:4-5
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/secrets-policies/secrets-policy-index/git-secrets-6

                4 |   secret_key = "BAD**********"

Check: CKV_SECRET_6: "Base64 High Entropy String"
        FAILED for resource: b5468ed07b9c1eb3cde57006c12d9da2c58b80dd
        File: /main.tf:38-39
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/secrets-policies/secrets-policy-index/git-secrets-6

                38 |   password             = "plai**********"
```