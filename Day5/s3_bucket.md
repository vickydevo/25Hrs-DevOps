# Simple AWS S3 Terraform (single-file)

Minimal single-file Terraform script (provider + resource). Edit the bucket name to a globally unique value before applying.

## Overview of Terraform Blocks

## Terraform Block
The `terraform` block declares which provider plugins are needed. Think of it as the power tool (like a drill) that provides the core functionality:
### terraform.tf
```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}
```



These blocks work together to define how Terraform will interact with AWS to create and manage resources.



## Provider Block
The `provider` block configures how to authenticate and operate the provider plugin. Think of it as the drill bit that determines how we'll interact with AWS:
### provider.tf
```hcl
provider "aws" {
    region = "us-east-1"  # Specifies where to create resources
}
```
## s3.tf
```hcl

resource "aws_s3_bucket" "bucket" {
    bucket = "terraform-vignan-1234" # replace with your unique name

}

```

## Install AWS CLI
- Linux:
    - Download/unzip installer:
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
- Windows (PowerShell): run the AWS CLI MSI installer from AWS (msi URL available in AWS docs)

## Configure AWS CLI (use IAM credentials)
1. Create an IAM user in the AWS Console:
     - Go to IAM → Users → Add user.
     - Enable "Programmatic access".
     - Attach existing policies → search and attach `AmazonS3FullAccess`.
     - Create user and download the Access key ID and Secret access key (CSV).
2. Locally run:
     `aws configure`
     - Enter Access Key ID, Secret Access Key, default region (e.g., us-east-1), and default output (json).

## Apply Terraform
1. In the directory with `main.tf`:
     - `terraform init`
     - `terraform plan`
     - `terraform apply` (confirm)
2. Delete or change `force_destroy` manually if you need to remove non-empty buckets (not enabled here).

Notes:
- Bucket names must be globally unique.
- For production, prefer KMS-managed encryption and least-privilege IAM policies instead of AmazonS3FullAccess.
- Keep credentials secure and rotate regularly.
