### Installl

```bash
brew install tfsec
```

### Run and Results

```bash
tfsec .
```

```
❯ tfsec .

======================================================
tfsec is joining the Trivy family

tfsec will continue to remain available
for the time being, although our engineering
attention will be directed at Trivy going forward.

You can read more here:
https://github.com/aquasecurity/tfsec/discussions/1994
======================================================

Result #1 CRITICAL Security group rule allows ingress from public internet.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:16
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    7    resource "aws_security_group" "open_sg" {
    .
   16  [     cidr_blocks      = ["0.0.0.0/0"]
   ..
   26    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-ec2-no-public-ingress-sgr
      Impact Your port exposed to the internet
  Resolution Set a more restrictive cidr range

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/ec2/no-public-ingress-sgr/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #2 CRITICAL Security group rule allows egress to multiple public internet addresses.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:24
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    7    resource "aws_security_group" "open_sg" {
    .
   24  [     cidr_blocks = ["0.0.0.0/0"]
   ..
   26    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-ec2-no-public-egress-sgr
      Impact Your port is egressing data to the internet
  Resolution Set a more restrictive cidr range

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/ec2/no-public-egress-sgr/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #3 CRITICAL Instance is exposed publicly.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:40
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33    resource "aws_db_instance" "unsecured_db" {
   ..
   40  [   publicly_accessible  = true (true)
   ..
   45    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-rds-no-public-db-access
      Impact The database instance is publicly accessible
  Resolution Set the database to not be publicly accessible

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/rds/no-public-db-access/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #4 HIGH No public access block so not blocking public acls
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-block-public-acls
      Impact PUT calls with public ACLs specified can make objects public
  Resolution Enable blocking any PUT calls with a public ACL specified

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/block-public-acls/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_acls
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #5 HIGH No public access block so not blocking public policies
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-block-public-policy
      Impact Users could put a policy that allows public access
  Resolution Prevent policies that allow public access being PUT

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/block-public-policy/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_policy
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #6 HIGH Bucket does not have encryption enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-enable-bucket-encryption
      Impact The bucket objects could be read if compromised
  Resolution Configure bucket encryption

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/enable-bucket-encryption/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#enable-default-server-side-encryption
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #7 HIGH No public access block so not ignoring public acls
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-ignore-public-acls
      Impact PUT calls with public ACLs specified can make objects public
  Resolution Enable ignoring the application of public ACLs in PUT calls

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/ignore-public-acls/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#ignore_public_acls
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #8 HIGH No public access block so not restricting public buckets
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-no-public-buckets
      Impact Public buckets can be accessed by anyone
  Resolution Limit the access to public buckets to only the owner or AWS Services (eg; CloudFront)

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/no-public-buckets/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#restrict_public_buckets¡
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #9 HIGH Bucket does not encrypt data with a customer managed key.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-encryption-customer-key
      Impact Using AWS managed keys does not allow for fine grained control
  Resolution Enable encryption using customer managed keys

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/encryption-customer-key/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#enable-default-server-side-encryption
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #10 HIGH Bucket has a public ACL: 'public-read-write'.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:30
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30  [   acl    = "public-read-write" ("public-read-write")
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-no-public-access-with-acl
      Impact Public access to the bucket can lead to data leakage
  Resolution Don't use canned ACLs or switch to private acl

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/no-public-access-with-acl/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #11 HIGH Instance has Public Access enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:40
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   40      publicly_accessible  = true
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  Rego Package builtin.aws.rds.aws0180
     Rego Rule deny
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #12 HIGH Instance does not have storage encryption enabled.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:41
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33    resource "aws_db_instance" "unsecured_db" {
   ..
   41  [   storage_encrypted    = false (false)
   ..
   45    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-rds-encrypt-instance-storage-data
      Impact Data can be read from RDS instances if compromised
  Resolution Enable encryption for RDS instances

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/rds/encrypt-instance-storage-data/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #13 MEDIUM Bucket does not have logging enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-enable-bucket-logging
      Impact There is no way to determine the access to this bucket
  Resolution Add a logging block to the resource to enable access logging

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/enable-bucket-logging/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #14 MEDIUM Bucket does not have versioning enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-enable-versioning
      Impact Deleted or modified data would not be recoverable
  Resolution Enable versioning to protect against accidental/malicious removal or modification

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/enable-versioning/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#versioning
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #15 MEDIUM Instance has very low backup retention period.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:33-45
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33  ┌ resource "aws_db_instance" "unsecured_db" {
   34  │   engine               = "mysql"
   35  │   instance_class       = "db.t2.micro"
   36  │   identifier           = "unsecured-db"
   37  │   username             = "admin"
   38  │   password             = "plaintextpassword"
   39  │   skip_final_snapshot  = true
   40  │   publicly_accessible  = true
   41  └   storage_encrypted    = false
   ..
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-rds-specify-backup-retention
      Impact Potential loss of data and short opportunity for recovery
  Resolution Explicitly set the retention period to greater than the default

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/rds/specify-backup-retention/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#backup_retention_period
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#backup_retention_period
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #16 MEDIUM Instance does not have IAM Authentication enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:33-45
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33  ┌ resource "aws_db_instance" "unsecured_db" {
   34  │   engine               = "mysql"
   35  │   instance_class       = "db.t2.micro"
   36  │   identifier           = "unsecured-db"
   37  │   username             = "admin"
   38  │   password             = "plaintextpassword"
   39  │   skip_final_snapshot  = true
   40  │   publicly_accessible  = true
   41  └   storage_encrypted    = false
   ..
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  Rego Package builtin.aws.rds.aws0176
     Rego Rule deny
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #17 MEDIUM Instance does not have Deletion Protection enabled
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:33-45
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33  ┌ resource "aws_db_instance" "unsecured_db" {
   34  │   engine               = "mysql"
   35  │   instance_class       = "db.t2.micro"
   36  │   identifier           = "unsecured-db"
   37  │   username             = "admin"
   38  │   password             = "plaintextpassword"
   39  │   skip_final_snapshot  = true
   40  │   publicly_accessible  = true
   41  └   storage_encrypted    = false
   ..
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  Rego Package builtin.aws.rds.aws0177
     Rego Rule deny
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #18 LOW Bucket does not have a corresponding public access block.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:28-31
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   28    resource "aws_s3_bucket" "public_bucket" {
   29      bucket = "insecure-open-bucket"
   30      acl    = "public-read-write"
   31    }
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-s3-specify-public-access-block
      Impact Public access policies may be applied to sensitive data buckets
  Resolution Define a aws_s3_bucket_public_access_block for the given bucket to control public access policies

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/s3/specify-public-access-block/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#bucket
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #19 LOW Instance does not have performance insights enabled.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  main.tf:33-45
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   33  ┌ resource "aws_db_instance" "unsecured_db" {
   34  │   engine               = "mysql"
   35  │   instance_class       = "db.t2.micro"
   36  │   identifier           = "unsecured-db"
   37  │   username             = "admin"
   38  │   password             = "plaintextpassword"
   39  │   skip_final_snapshot  = true
   40  │   publicly_accessible  = true
   41  └   storage_encrypted    = false
   ..
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-rds-enable-performance-insights
      Impact Without adequate monitoring, performance related issues may go unreported and potentially lead to compromise.
  Resolution Enable performance insights

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.12/checks/aws/rds/enable-performance-insights/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance#performance_insights_kms_key_id
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#performance_insights_kms_key_id
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


  timings
  ──────────────────────────────────────────
  disk i/o             20.854µs
  parsing              468.027µs
  adaptation           128.894µs
  checks               12.472214ms
  total                13.089989ms

  counts
  ──────────────────────────────────────────
  modules downloaded   0
  modules processed    1
  blocks processed     4
  files read           1

  results
  ──────────────────────────────────────────
  passed               3
  ignored              0
  critical             3
  high                 9
  medium               5
  low                  2

  3 passed, 19 potential problem(s) detected.
```