# 🚀 Terraform Installation Guide

This guide provides instructions for installing **HashiCorp Terraform** on two popular Linux distributions: **Amazon Linux 2023** and **Ubuntu**.

## Prerequisites

* A user account with **sudo** privileges.
* An active internet connection.

---

## 1. Installation on Ubuntu (Recommended Method: HashiCorp Repository)

The most reliable way to install Terraform on Ubuntu is by using the official HashiCorp Linux repository. This ensures you get the latest stable version and can easily update.

### Steps:

1.  Update the package list and install necessary dependencies:

    ```bash
    sudo apt update
    sudo apt install -y software-properties-common wget
    ```
    <img width="1000" height="500" alt="Image" src="https://github.com/user-attachments/assets/56e7da6b-5b1b-49b7-84c4-ee41d998835f" />

2.  Download the HashiCorp GPG key:

    ```bash
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    ```
    <img width="1400" height="612" alt="Image" src="https://github.com/user-attachments/assets/3aae4d47-8198-41aa-8ed1-3be841298a4c" />

3.  Add the official HashiCorp repository:

    ```bash
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    ```
    <img width="1932" height="376" alt="Image" src="https://github.com/user-attachments/assets/b5beaff7-e4a7-4c18-a0b7-f2d17ac29924" />

4.  Update and install Terraform:

    ```bash
    sudo apt update
    sudo apt install terraform
    ```
    <img width="1918" height="792" alt="Image" src="https://github.com/user-attachments/assets/760c5802-ef88-47cd-856d-6f179ce272aa" />

5.  Verify the installation:

    ```bash
    terraform --version
    ```
    <img width="1024" height="205" alt="Image" src="https://github.com/user-attachments/assets/617fc8cc-07f9-40ab-b2c1-96c96454d356" />

---
## 2. Configure AWS credentials and Terraform

Follow these steps to create an IAM user with programmatic access, configure the AWS CLI, and connect Terraform to AWS.

### A. Install AWS CLI (Linux example)
```bash
# Linux (x86_64) - AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
```
(For macOS use `brew install awscli`; for Windows use the MSI installer from AWS docs.)

### B. Create an IAM user (via AWS Console)
1. Sign in to the AWS Management Console with an admin account.  
2. Open the IAM service → Users → Add user.  
3. Enter a username (e.g., terraform-user). Select "Programmatic access".  
4. Click "Next: Permissions". Choose one of:
    - For testing: attach the managed policy `AdministratorAccess` (NOT for production).
    - For production: create/attach least-privilege policies that only allow needed actions (recommended).
    - Example managed policies to consider: `AmazonEC2FullAccess`, `AmazonS3FullAccess`, etc., or a custom policy scoped to required resources.
5. Continue to Review → Create user.  
6. Save the Access key ID and Secret access key (you will not be able to view the secret again). Store them securely.

### C. Configure AWS CLI credentials
Option 1 — configure a named profile (recommended):
```bash
aws configure --profile terraform
# Enter Access Key ID, Secret Access Key, default region (e.g., us-east-1), default output (json)
```
Option 2 — export environment variables (useful for CI):
```bash
export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=us-east-1
# or set AWS_PROFILE=terraform
export AWS_PROFILE=terraform
```

### D. Minimal Terraform provider and verification
Create a small README-friendly Terraform snippet to verify credentials:

```hcl
# providers.tf
terraform {
  required_providers {
     aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
     }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform" # remove if using env vars (AWS_ACCESS_KEY_ID / SECRET)
}

data "aws_caller_identity" "current" {}
output "aws_account_id" { value = data.aws_caller_identity.current.account_id }
output "aws_user_arn"    { value = data.aws_caller_identity.current.arn }
```

Run:
```bash
terraform init
terraform apply -auto-approve
# Expect outputs showing the account ID and caller ARN (verifies credentials are working)
```

### E. Recommended best practices
- Use least privilege when assigning IAM permissions; avoid AdministratorAccess in production.
- Use named profiles, environment variables, or IAM roles (EC2/ECS) instead of hardcoding credentials in files.
- Rotate credentials regularly and enable MFA on privileged accounts.
- Store secrets in a secure secrets manager (AWS Secrets Manager, Vault, GitHub Actions secrets).
- Use remote state (e.g., S3 + DynamoDB locking) for Terraform in team environments.

### F. Troubleshooting quick tips
- "InvalidClientTokenId" / "AccessDenied": check keys, region, policy permissions, and profile.
- "NoCredentialProviders": ensure AWS_PROFILE or AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY are set for the environment where Terraform runs.
- For CI/CD, inject credentials via environment variables or native platform integrations (GitHub Actions OIDC, AWS CodeBuild roles).

This README content can be appended below your Terraform installation section to guide users through IAM creation, AWS CLI configuration, and testing Terraform connectivity to AWS.