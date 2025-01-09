### Installl

```bash
brew install terrascan
```

### Run and Results

```bash
terrascan scan
```

```
❯ terrascan scan
2025/01/07 22:19:46 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions


Scan Errors -

        IaC Type            :   arm
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   ARM files not found in the directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------

        IaC Type            :   docker
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   Dockerfile not found in the directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------

        IaC Type            :   cft
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   cft files not found in the directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------

        IaC Type            :   k8s
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   kubernetes files not found in the directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------

        IaC Type            :   kustomize
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   kustomization.y(a)ml file not found in the directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------

        IaC Type            :   helm
        Directory           :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        Error Message       :   no helm charts found in directory /home/diego/git/diegopacheco/devops-playground/terrascan-fun

        -----------------------------------------------------------------------



Violation Details -

        Description    :        Ensure CloudWatch logging is enabled for AWS DB instances
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        33
        Severity       :        MEDIUM
        -----------------------------------------------------------------------

        Description    :        Ensure that your RDS database has IAM Authentication enabled.
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        33
        Severity       :        MEDIUM
        -----------------------------------------------------------------------

        Description    :        RDS Instance publicly_accessible flag is true
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        33
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Enabling S3 versioning will enable easy recovery from both unintended user actions, like deletes and overwrites
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        28
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Ensure automated backups are enabled for AWS RDS instances
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        33
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        28
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Ensure no security groups is wide open to public, that is, allows traffic from 0.0.0.0/0 to ALL ports and protocols
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        7
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Misconfigured S3 buckets can leak private information to the entire internet or allow unauthorized data tampering / deletion
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        28
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Ensure that your RDS database instances encrypt the underlying storage. Encrypted RDS instances use the industry standard AES-256 encryption algorithm to encrypt data on the server that hosts RDS DB instances. After data is encrypted, RDS handles authentication of access and description of data transparently with minimal impact on performance.
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        33
        Severity       :        HIGH
        -----------------------------------------------------------------------


Scan Summary -

        File/Folder         :   /home/diego/git/diegopacheco/devops-playground/terrascan-fun
        IaC Type            :   terraform
        Scanned At          :   2025-01-08 06:19:47.68781045 +0000 UTC
        Policies Validated  :   154
        Violated Policies   :   9
        Low                 :   0
        Medium              :   2
        High                :   7
```