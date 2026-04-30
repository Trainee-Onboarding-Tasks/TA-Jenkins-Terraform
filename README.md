# TA-Jenkins-Terraform


# Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup & Run](#setup--run)
- [Access Jenkins Server (via SSM)](#access-jenkins-server-via-ssm)
- [Switching users inside EC2 (via SSM)](#switching-users-inside-ec2-via-ssm)


---

# Overview
This repository provisions a secure AWS system infrastructure using Terraform, including:

- A custom AWS VPC
- An EC2 instance running Jenkins
- No SSH access and no public exposure (SSM-only access)

---


# Prerequisites

### Before using this repository, ensure the following are installed and configured on your local machine:

1. AWS CLI is installed on local PC and cofigured with required creds

2. HashiCorp Terraform is installed

3. S3 bucket must exist before deploying infrastructure, in this case it is:
    ```bash
    terraform {
        required_version = ">=1.5.0"

        backend "s3" {
            bucket   = "trainee-onboarding-tasks"
            key      = "jenkins/state"
            region   = "us-east-1"
            encrypt  = true
        }
    }
    ```

3. (Optional) Packer for AMI creation

    Before running this infrastructure, ensure a Jenkins AMI exists in your AWS account. If it does NOT exist, you must create it using this repository:
    https://github.com/Trainee-Onboarding-Tasks/TA-AMI-Packer.git

---


# Setup & Run

1. Clone repository and move to root folder:
    ```bash
    git clone https://github.com/Trainee-Onboarding-Tasks/TA-Jenkins-Terraform.git
    cd TA-Jenkins-Terraform
    ```


2. In root file `variables.tf`, configure variables:
    ```bash
    
    variable "aws_region" {
      type        = string
      description = "AWS region to deploy resources"
      default     = "us-east-1"
    }


    variable "jenkins_server_ami_id" {
      type        = string
      description = "AMI ID for Jenkins server"
      default     = "ami-02aeb3c8edb7fcc8d"
    }


    variable "jenkins_server_instance_type" {
        type        = string
        description = "EC2 instance type for Jenkins server"
        default     = "t3.medium"
    }

    ```
there are special variables - AWS region where resources will be deployed, AMI ID for Jenkins EC2 instance (must be prebuilt via Packer) and EC2 instance type (e.g. t3.large)


3. Run:
- ```bash
    terraform init
    ```

to initialize terraform project and:

- ```bash
    terraform apply -auto-approve
   ```

to build infrastructure.

---

# Access Jenkins Server (via SSM)

#### This Jenkins server is not exposed to the public internet. All access is performed exclusively via AWS Systems Manager (SSM)

1. After Terraform deployment, the EC2 Instance ID will be available in Terraform outputs, to view it, run:
    ```bash
    terraform output
    ```
this value is required for SSM access

2. Start SSM session (shell access):

    ```bash
    aws ssm start-session --target <INSTANCE_ID> --region us-east-1
    ```

3. Access Jenkins UI via port forwarding:

    ```bash
    aws ssm start-session \
    --target <INSTANCE_ID> \
    --region us-east-1 \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["8080"],"localPortNumber":["8080"]}'
    ```

4. After starting port forwarding, open Jenkins in browser:
    ```bash
    http://localhost:8080
    ```

5. Get Jenkins initial admin password
    #### (Important) This password is required only once during the initial Jenkins setup. After the first login and setup completion, it is no longer needed for daily usage.


    Inside the EC2 instance (via SSM session), run:
    ```bash
    cat /var/lib/jenkins/secrets/initialAdminPassword
    ```
    copy and paste this password in browser Jenkins page

---


# Switching users inside EC2 (via SSM)

#### After connecting to the instance using SSM, you can switch to a different user if needed. Jenkins typically runs under its own system user (`jenkins`)

For example:
```bash
sudo su -
```

or (Ubuntu-based systems):

```bash
sudo su - ubuntu
```