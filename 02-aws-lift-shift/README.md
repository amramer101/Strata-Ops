# vProfile Cloud Lift & Shift - AWS IaaS Migration

## Project Summary

A production-grade **Lift & Shift (Rehosting)** migration of a multi-tier Java web application from on-premises infrastructure to AWS Cloud using a fully automated Infrastructure as Code (IaC) approach. This project demonstrates enterprise-level cloud migration patterns, hybrid automation strategies, and AWS best practices for secure, scalable infrastructure deployment.

## Architecture Overview

This solution implements a three-tier architecture across isolated network layers:

**Traffic Flow:**
1. End users access the application through an Internet Gateway
2. Nginx reverse proxy (public subnet) handles incoming requests and SSL termination
3. Application layer (Tomcat) processes business logic in a private subnet
4. Backend services (MySQL, RabbitMQ, Memcached) operate in isolated private subnets
5. All private instances route outbound traffic through a NAT Gateway for security

**Service Discovery:** Internal service communication uses AWS Route53 Private Hosted Zone (`eprofile.in`) with DNS records for each backend service (db01, mc01, rmq01, app01).

## Technical Implementation

### 1. Infrastructure as Code (Terraform)

**100% automated provisioning** of all AWS resources:
- VPC with custom CIDR (10.0.0.0/16) in eu-central-1
- Multi-AZ deployment across 3 availability zones
- Public subnets (10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24)
- Private subnets (10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24)
- Internet Gateway and NAT Gateway configuration
- Route tables with proper routing policies
- Security Groups with least-privilege access rules
- 5 EC2 instances with custom User Data scripts

### 2. Hybrid Automation Strategy: Artifact Lifecycle Management

**Key Innovation:** Terraform manages not only infrastructure but also the complete artifact deployment pipeline:

```hcl
# Terraform creates S3 bucket
resource "aws_s3_bucket" "Artifact-Bucket"

# Terraform uploads Java WAR file from local machine to S3
resource "aws_s3_object" "artifact" {
  bucket = aws_s3_bucket.Artifact-Bucket.id
  key    = "vprofile-v2.war"
  source = "../target/vprofile-v2.war"
  etag   = filemd5("../target/vprofile-v2.war")
}

# EC2 User Data downloads artifact on boot
#!/bin/bash
aws s3 cp s3://bucket-name/vprofile-v2.war /opt/tomcat/webapps/
```

**Benefits:**
- Single source of truth for infrastructure AND application artifacts
- Eliminates manual artifact transfers
- Ensures consistent deployments across environments
- Version control for both code and binaries

### 3. Security & IAM Best Practices

**IAM Role-Based Access (No Hardcoded Credentials):**
- **IAM Role:** `ec2-s3-access-role` with AssumeRole policy for EC2 service
- **IAM Policy:** `s3-access-policy` grants GetObject permissions on artifact bucket
- **Instance Profile:** `ec2-s3-instance-profile` attaches role to EC2 instances
- **Attachment:** Role automatically propagated to Tomcat, MySQL, RabbitMQ, Memcached instances

**Result:** EC2 instances securely access S3 using temporary credentials via AWS STS, following AWS Well-Architected Framework security pillar.

### 4. Network Isolation & Defense in Depth

#### Public Subnet Components:
- **Nginx EC2 Instance:** Reverse proxy with public IP, internet-facing
- **NAT Gateway:** Provides secure outbound internet access for private instances
- **Internet Gateway:** Entry/exit point for public traffic

#### Private Subnet Components (No Public IPs):
- **Tomcat (Application Server):** Java EE runtime hosting vProfile WAR
- **MySQL (Database):** Relational database for persistent storage
- **RabbitMQ (Message Queue):** Asynchronous messaging service
- **Memcached (Cache):** Distributed in-memory caching layer

**NAT Gateway Usage:**
- Private instances cannot receive inbound traffic from the internet
- Outbound traffic (package updates, API calls) routes through NAT Gateway
- NAT Gateway in public subnet translates private IPs to its Elastic IP
- Provides internet access while maintaining zero inbound exposure

**Security Groups:**
- Nginx: Allows inbound 80/443 from 0.0.0.0/0, outbound to Tomcat
- Tomcat: Allows inbound 8080 only from Nginx SG, outbound to backend services
- MySQL: Allows inbound 3306 only from Tomcat SG
- RabbitMQ: Allows inbound 5672 only from Tomcat SG
- Memcached: Allows inbound 11211 only from Tomcat SG

### 5. Service Discovery with Route53 Private Hosted Zone

**DNS-Based Internal Communication:**
```
Private Zone: eprofile.in
├── app01.eprofile.in  → Tomcat private IP
├── db01.eprofile.in   → MySQL private IP
├── mc01.eprofile.in   → Memcached private IP
└── rmq01.eprofile.in  → RabbitMQ private IP
```

**Benefits:**
- Decouples application code from infrastructure (no hardcoded IPs)
- Enables seamless instance replacement without code changes
- Supports blue-green deployments and disaster recovery
- DNS TTL of 300 seconds balances propagation speed and caching

### 6. EC2 Instance Configuration

| Instance | Type | Subnet | Public IP | Role |
|----------|------|--------|-----------|------|
| Nginx | t2.micro | Public | Yes | Reverse Proxy / Load Balancer |
| Tomcat | t2.micro | Private | No | Java Application Server |
| MySQL | t2.micro | Private | No | Relational Database |
| RabbitMQ | t2.micro | Private | No | Message Broker |
| Memcached | t2.micro | Private | No | Cache Layer |

**User Data Automation:**
- All instances run Bash scripts on first boot
- Package installation (nginx, tomcat9, mysql-server, rabbitmq-server, memcached)
- Service configuration and startup
- Artifact download from S3 (Tomcat only)
- Application deployment and initialization

### 7. SSH Access & Key Management

- **Key Pair:** `EC2_Key_Pair` (SSH ED25519) provisioned via Terraform
- **Bastion Pattern:** Access private instances by SSH jumping through Nginx (public)
- **Commands Generated:** Terraform outputs SSH commands for each instance

## Tools & Technologies

| Category | Technology |
|----------|-----------|
| **IaC** | Terraform 1.14.0 |
| **Cloud Provider** | AWS (eu-central-1) |
| **Compute** | EC2 (t2.micro) |
| **Networking** | VPC, Internet Gateway, NAT Gateway, Route53 |
| **Storage** | S3 (Artifact storage) |
| **Security** | IAM Roles, Instance Profiles, Security Groups |
| **Application** | Java, Tomcat 9, Nginx |
| **Database** | MySQL 8.0 |
| **Middleware** | RabbitMQ, Memcached |
| **Source Control** | Git |

## Key Features

✅ **Full Infrastructure Automation** - Zero manual AWS console clicks required  
✅ **Artifact Management** - S3-based deployment pipeline integrated into Terraform  
✅ **Zero Hardcoded Credentials** - IAM roles with temporary STS credentials  
✅ **Network Segmentation** - Public/private subnet isolation with NAT Gateway  
✅ **Service Discovery** - DNS-based internal routing (no IP hardcoding)  
✅ **Multi-AZ Deployment** - High availability across 3 availability zones  
✅ **Automated Bootstrapping** - User Data scripts configure services on boot  
✅ **Immutable Infrastructure** - Destroy and recreate entire stack in minutes  
✅ **Cost Optimized** - t2.micro instances, single NAT Gateway, no redundant resources  
✅ **Production Ready** - Security groups, private subnets, encrypted S3 storage  

## Deployment Architecture

```
Internet
    ↓
Internet Gateway
    ↓
[Public Subnet: 10.0.0.0/24]
    ├── Nginx (Reverse Proxy) → Public IP: Yes
    └── NAT Gateway → Elastic IP
         ↓
[Private Subnet: 10.0.4.0/24]
    ├── Tomcat (app01.eprofile.in) → Downloads WAR from S3
    ├── MySQL (db01.eprofile.in)
    ├── RabbitMQ (rmq01.eprofile.in)
    └── Memcached (mc01.eprofile.in)

[Terraform Workflow]
Local Machine → S3 Upload (vprofile-v2.war)
              → Terraform Apply → AWS Resources
```

## Project Outcomes

- **Migration Time:** Fully automated deployment in <10 minutes
- **Security Posture:** Zero public exposure of backend services
- **Operational Excellence:** Infrastructure versioned in Git, reproducible deployments
- **Cost Efficiency:** Pay-as-you-go model, no over-provisioning
- **Scalability Foundation:** Ready for Auto Scaling Groups, ALB integration, RDS migration

## Future Enhancements

- Migrate to Application Load Balancer (ALB) for advanced routing
- Convert MySQL to RDS for managed database service
- Implement Auto Scaling Groups for Tomcat tier
- Add CloudWatch monitoring and SNS alerting
- Integrate AWS Systems Manager for centralized patching
- Implement AWS Secrets Manager for database credentials
- Add WAF (Web Application Firewall) for DDoS protection

---

**Project Type:** Cloud Migration (Lift & Shift / Rehosting)  
**Deployment Region:** eu-central-1 (Frankfurt)  
**Infrastructure State:** Fully managed by Terraform  
**Artifact Source:** Local build → S3 → EC2 User Data download  

**Author:** Senior DevOps Engineer  
**Date:** February 2026