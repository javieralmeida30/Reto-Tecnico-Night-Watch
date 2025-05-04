# ☁️ Reto Técnico - Night Watch
### AWS Architecture with Grafana Monitoring, PostgreSQL Server, Kubernetes (K3s), and S3 Logs

This project builds a simple but solid AWS infrastructure, including:
- A **Grafana server** (bastion host) to monitor resources
- A **PostgreSQL server** in a private subnet
- **Metrics and logs** exported daily to **Amazon S3**
- Infrastructure managed with **Terraform** (IaC)
- Basic **CloudWatch** monitoring
- Custom **scripts** for backups and metrics export

---

# Prerequisites

Before running the project, make sure you have:

- [Terraform](https://www.terraform.io/downloads) installed (tested on **Terraform v1.5+**)
- [AWS CLI](https://aws.amazon.com/cli/) configured locally (`aws configure`)
- An AWS account
- An **SSH key pair** (`.pem` file) for EC2 access
- An IAM user with the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "s3:*",
        "iam:*",
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

# How to Deploy

1. **Clone** the repository:
   ```bash
   git clone https://github.com/javieralmeida30/Reto-Tecnico-Night-Watch.git
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the execution plan**:
   ```bash
   terraform plan
   ```

4. **Apply the infrastructure**:
   ```bash
   terraform apply
   ```

After a few minutes, Terraform will output:
- Bastion host **public IP**
- PostgreSQL server **private IP**
- **Grafana** access URL
- **S3 bucket** name for backups
Use the terraform command `terraform output` to export the outputs: terraform output > outputs.txt

---

# Infrastructure Architecture

![AWS Architecture Diagram](/images/NightWatchArquitecture.png)


 Components:
 - VPC: 10.0.0.0/16
 - Public Subnet: EC2 Bastion Host (Grafana) 
 - Private Subnet: EC2 PostgreSQL Server 
 - S3 Bucket: Stores logs and metrics 
 - CloudWatch: Monitors EC2 instances 
 - NAT Gateway: Internet access for private subnet 
 - Security Groups: Control access between instances 

---
# VPC Architecture
![AWS VPC Diagram](/images/NightWatchVPCArquitecture.png)


 Components:
 - 2 Public Subnets: resources that require direct internet access
 - 2 Private Subnets: internal services like databases
 - Internet Gateway: allowing public subnets to reach the internet
 - NAT Gateway: placed in a public subnet, enabling private subnets to access the internet securely
 - Availability Zones: distributed to ensure high availability and fault tolerance
 - Elastic IP: Associate to NAT Gateway
---

#  Terraform Modules Structure

Modules:
- `vpc` Creates VPC, Subnets, NAT Gateway, Internet Gateway
- `ec2` Bastion host and private PostgreSQL EC2 
- `s3` Bucket for backups and metrics 
- `security_groups` Rules to control traffic between instances 
- `(Optional) route53`: Pre-configured module for future DNS assignment

Outputs:
- Public and private IPs
- Grafana access URL
- S3 bucket name

---

# Available Scripts

Scripts are located in `/scripts`:

Scripts:
- `grafana_user_data.sh`  User data for bastion EC2 (Docker + Grafana setup) 
- `postgres_user_data.sh`  User data for PostgreSQL EC2 (Docker + PostgreSQL setup) 
- `postgresql_daily_backup.sh`  Backs up PostgreSQL database daily to S3 
- `ec2_logs_to_s3.py`  Collects CloudWatch metrics and uploads to S3 
- `setup_scripts.sh`  Uploads scripts via SSH, deploys Nginx and Prometheus on Kubernetes, and configures backups

---

# Monitoring in Grafana

- Query the PostgreSQL server time:
  ```sql
  SELECT now() AS current_time;
  ```
- Monitor EC2 instance **CPU utilization** and **network metrics**.
- Create alerts inside Grafana.

---

# Useful commands

Terraform:
- `terraform init`  Initialize Terraform project
- `terraform plan`  Preview changes
- `terraform apply` Deploy infrastructure
- `terraform destroy` Tear down infrastructure
- `terraform output` Show output values
AWS CLI:
- `aws configure` Configure aws credentials
- `aws s3 ls` List all buckets
- `aws s3 ls s3://your-bucket-name` List objects in a specific bucket
- `aws ec2 describe-instances` List EC2 instances
SSH Access:
- `ssh -i your-key.pem ec2-user@<public-ip>` Connect to EC2 instance
Kubernetes (K3s / kubectl):
- `kubectl get pods -A` Show all pods in all namespaces
- `kubectl get nodes` Show nodes in the cluster
- `kubectl describe pod <pod-name>` Details of a specific pod
- `kubectl logs <pod-name>` Logs from a pod
Docker:
- `docker ps` List running containers
- `docker ps -a` List all containers
- `docker images` List download images
- `docker exec -it <container-id> /bin/bash` Access a container
- `docker logs` Show container logs