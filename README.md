# Strata-Ops: The Ultimate DevSecOps Evolution Journey

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stage](https://img.shields.io/badge/Stage-Production%20Ready-brightgreen)](https://github.com/amramer101/Strata-Ops)
[![Terraform](https://img.shields.io/badge/Terraform-v1.6+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/K8s-v1.29-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS%2FECR%2FRDS-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Security](https://img.shields.io/badge/Security-DevSecOps%20Shift--Left-red?logo=owasp)](https://owasp.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)

> **🎯 Mission:** Document a complete engineering transformation of the `VProfile` application—evolving from a simple local virtualized environment to a **production-grade, cloud-native Kubernetes architecture on AWS EKS**, implementing **GitOps**, **Zero-Trust Security**, **OIDC Authentication**, and **Infrastructure as Code (IaC)**.

---

## 📑 Table of Contents

1. [🌍 Project Overview](#-project-overview)
2. [🗺️ The Journey Through 6 Phases](#-the-journey-through-6-phases)
3. [📊 Project Roadmap & Evolution](#-project-roadmap--evolution)
4. [🏗️ Phase 1: Local Foundation](#-phase-1-local-foundation)
5. [☁️ Phase 2: AWS Lift & Shift](#-phase-2-aws-lift--shift)
6. [🌩️ Phase 3: Cloud-Native PaaS](#-phase-3-cloud-native-paas)
7. [🐳 Phase 4.1: Containerization & Ansible](#-phase-41-containerization--ansible)
8. [⚡ Phase 4.2: Serverless Containers (ECS Fargate)](#-phase-42-serverless-containers-ecs-fargate)
9. [🎮 Phase 5.1: Self-Managed Kubernetes](#-phase-51-self-managed-kubernetes-on-ec2)
10. [📦 Phase 5.2: Helm Packaging & Templating](#-phase-52-helm-packaging--templating)
11. [🚀 Phase 6.1: Production EKS with GitOps](#-phase-61-production-eks-with-gitops--oidc)
12. [📈 Performance & Cost Comparison](#-performance--cost-comparison)
13. [🛡️ Best Practices & Lessons Learned](#-best-practices--lessons-learned)
14. [📂 Repository Structure](#-repository-structure)

---

## 🌍 Project Overview

**Strata-Ops** is more than just a repository—it's a **comprehensive DevOps learning journey** documented through six progressive phases of infrastructure evolution.

### What Makes This Different?

- 🎓 **Educational Foundation**: Every phase is self-contained and builds on previous knowledge
- 🏭 **Production-Ready Code**: Not theory—actual, deployable infrastructure
- 📚 **Complete Documentation**: Screenshots, diagrams, and step-by-step guides
- 🔐 **Security-First**: DevSecOps practices integrated throughout
- 🔄 **Reproducible**: Infrastructure as Code for 100% consistency
- ⚡ **Real Metrics**: Deployment time, cost analysis, and performance data

### The Application: VProfile (5-Tier Java Application)

```
┌─────────────────────────────────────────────────┐
│              🌐 Nginx (Web Tier)                │
│             Reverse Proxy • Port 80              │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│           ☕ Tomcat (App Tier)                   │
│     Java Application Server • Port 8080          │
└──┬────────────┬──────────────┬──────────────────┘
   │            │              │
   ▼            ▼              ▼
┌─────┐    ┌─────────┐    ┌──────┐
│MySQL│    │Memcached│    │RabbitMQ│
│ DB  │    │ Cache   │    │ Queue  │
└─────┘    └─────────┘    └──────┘
```

**Services:**
- **Tomcat**: Java application server running VProfile
- **MySQL**: Relational database (user accounts, profiles)
- **Memcached**: In-memory caching layer
- **RabbitMQ**: Message broker for async operations
- **Nginx**: Reverse proxy and frontend gateway

---

## 🗺️ The Journey Through 6 Phases

This project is structured as a **layered geological model** where each phase represents a deeper understanding of infrastructure engineering:

```
           🌍 Surface
             │
       ┌─────▼─────┐
       │  Phase 6   │ ← Production EKS with GitOps (CURRENT)
       ├───────────┤
       │  Phase 5   │ ← Kubernetes Mastery
       ├───────────┤
       │  Phase 4   │ ← Containerization & Orchestration
       ├───────────┤
       │  Phase 3   │ ← Cloud-Native Services
       ├───────────┤
       │  Phase 2   │ ← AWS Infrastructure
       ├───────────┤
       │  Phase 1   │ ← Local Foundation
       └───────────┘
```

Each phase adds complexity, introduces new technologies, and builds on the previous layer's understanding.

---

## 📊 Project Roadmap & Evolution

This repository represents more than just code migration; it is an evolution of **Engineering Mindset**:

| Phase | Platform | Deployment Strategy | Security Posture | Observability | Status | Time | Key Learning |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **1** | VirtualBox (Local) | Manual SSH/SCP | Basic SSH Keys | Log Files | ✅ | 45m | Fundamentals |
| **2** | AWS EC2 (IaaS) | Jenkins Pipeline | Security Groups | Prometheus/Grafana | ✅ | 20m | Infrastructure as Code |
| **3** | Elastic Beanstalk (PaaS) | AWS CodePipeline | WAF + Secrets Mgr | CloudWatch | ✅ | 15m | Managed Services |
| **4.1** | Docker Compose | Ansible Playbooks | Container Linting | Docker Stats | ✅ | 12m | Containerization |
| **4.2** | AWS ECS Fargate | GitHub Actions | Trivy + Checkov | Datadog APM | ✅ | 8m | DevSecOps CI/CD |
| **5.1** | Self-Managed K8s | Kubeadm (Manual) | Network Policies | Metrics Server | ✅ | 25m | Kubernetes Internals |
| **5.2** | Kubernetes (Helm) | Helm Charts | RBAC + Secrets | Prometheus Stack | ✅ | 10m | Helm Templating |
| **6.1** | **AWS EKS (Prod)** | **GitOps (OIDC)** | **IRSA + Immutable Tags** | **CloudWatch + X-Ray** | ✅ **Live** | **3m** | **Production Enterprise** |

---

## 🏗️ Phase 1: Local Foundation

**Goal:** Establish a baseline local environment to understand the 3-Tier Architecture components.

### What You'll Learn
- ✅ Multi-tier application architecture principles
- ✅ Manual service provisioning and configuration
- ✅ Network connectivity and firewall rules
- ✅ Database initialization and schema management
- ✅ Foundation for all future automation

### Key Highlights
- **Infrastructure:** 3-5 VMs (App, DB, LB, Cache, Queue) via Vagrant & VirtualBox
- **Challenge:** Manually managing version compatibility (Java, Tomcat, MySQL)
- **Outcome:** A functioning local application ready for cloud migration
- **Setup Time:** 45-60 minutes

### 📸 Architecture Diagram
<div align="center">
  <img src="media/Lift-shift/local-arch.png" alt="Phase 1 Architecture" width="600"/>
  <p><i>Figure 1: Basic Local Virtualized 5-Tier Architecture</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 1 Documentation →](1-Local-Foundation/README.md)**
- **Manual Setup:** [1.1-Local-Setup-Manual/README.md](1.1-Local-Setup-Manual/README.md)
- **Automated Setup:** [1.2-Local-Setup-Automated-Vagrand/README.md](1.2-Local-Setup-Automated-Vagrand/README.md)

### Quick Start
```bash
cd 1-Local-Foundation
vagrant up
# Then manually configure each service (see documentation)
```

---

## ☁️ Phase 2: AWS Lift & Shift

**Goal:** Migrate to AWS IaaS while automating infrastructure provisioning (IaC).

### What You'll Learn
- ✅ Infrastructure as Code fundamentals (Terraform)
- ✅ AWS networking (VPC, subnets, security groups)
- ✅ EC2 auto-scaling and elastic load balancing
- ✅ Managed database services (RDS)
- ✅ CI/CD with Jenkins
- ✅ Observability with Prometheus & Grafana

### Key Highlights
- **Infrastructure:** EC2 instances within an Auto Scaling Group managed by Terraform
- **Database:** Migration to Amazon RDS (MySQL) for managed backups and HA
- **CI/CD:** Jenkins Pipeline for automated WAR building and deployment
- **Observability:** Grafana and Prometheus for real-time metric visualization
- **Deployment Time:** 20 minutes (improvement: 55% ⬇️)

### 📸 Architecture Diagram
<div align="center">
  <img src="media/Lift-shift/lift-shift-arch.png" alt="Phase 2 Architecture" width="600"/>
  <p><i>Figure 2: Lift & Shift Architecture on EC2 with RDS and Jenkins</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 2 Documentation →](2-AWS-Lift-And-Shift/README.md)**
- **[Terraform Code →](2-AWS-Lift-And-Shift/terraform/)**
- **[Jenkins Configuration →](2-AWS-Lift-And-Shift/jenkins/)**

### Quick Start
```bash
cd 2-AWS-Lift-And-Shift
terraform init
terraform plan
terraform apply
```

---

## 🌩️ Phase 3: Cloud-Native PaaS

**Goal:** Reduce operational overhead by leveraging AWS Platform-as-a-Service.

### What You'll Learn
- ✅ Managed application platforms (Elastic Beanstalk)
- ✅ Pipeline automation (AWS CodePipeline)
- ✅ Security services (WAF, Secrets Manager)
- ✅ Reduced operational complexity
- ✅ Infrastructure abstraction and scaling

### Key Highlights
- **Platform:** AWS Elastic Beanstalk for abstracted application hosting
- **CI/CD:** AWS CodePipeline for seamless integration with source control
- **Security:** Integration of AWS WAF and Secrets Manager for credential management
- **Benefit:** Focus shifts entirely to code development rather than server management
- **Deployment Time:** 15 minutes (improvement: 67% ⬇️)

### 📸 Architecture Diagram
<div align="center">
  <img src="media/cloud-native/cloud-native-arch.png" alt="Phase 3 Architecture" width="600"/>
  <p><i>Figure 3: Fully Managed PaaS Architecture with CodePipeline</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 3 Documentation →](3-Cloud-Native-PaaS/README.md)**
- **[CloudFormation Templates →](3-Cloud-Native-PaaS/cloudformation/)**

---

## 🐳 Phase 4.1: Containerization & Ansible

**Goal:** Decouple applications from infrastructure using Docker and ensure environment consistency.

### What You'll Learn
- ✅ Docker fundamentals and multi-stage builds
- ✅ Container networking and volumes
- ✅ Docker Compose for local orchestration
- ✅ Infrastructure provisioning with Ansible
- ✅ Configuration management best practices

### Key Highlights
- **Technology:** Docker Compose for multi-container orchestration locally
- **Configuration:** Ansible playbooks for automated server provisioning
- **Benefit:** Elimination of "It works on my machine" issues
- **Deployment Time:** 12 minutes
- **Manual Steps:** Reduced significantly

### 📸 Architecture Diagram
<div align="center">
  <img src="media/Docker-compose/docker-compose-arch.png" alt="Phase 4.1 Architecture" width="600"/>
  <p><i>Figure 4: Local Containerized Architecture with Ansible Configuration</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 4.1 Documentation →](4.1-Docker-Compose-Ansible/README.md)**
- **[Dockerfile →](4.1-Docker-Compose-Ansible/Dockerfile)**
- **[Docker Compose File →](4.1-Docker-Compose-Ansible/docker-compose.yml)**
- **[Ansible Playbooks →](4.1-Docker-Compose-Ansible/ansible/)**

---

## ⚡ Phase 4.2: Serverless Containers (ECS Fargate)

**Goal:** Run containers without managing servers, integrated with a modern CI/CD pipeline.

### What You'll Learn
- ✅ AWS ECS and Fargate serverless containers
- ✅ Container registries (ECR)
- ✅ Advanced CI/CD with GitHub Actions
- ✅ DevSecOps best practices (shift-left security)
- ✅ Container security scanning (Trivy, Checkov)
- ✅ Distributed tracing (Datadog APM)

### Key Highlights
- **Platform:** AWS ECS Fargate (Serverless Compute)
- **CI/CD:** GitHub Actions with integrated security scanning (Trivy, Checkov)
- **Observability:** Datadog APM integration for distributed tracing
- **Security:** Container linting and vulnerability scanning
- **Deployment Time:** 8 minutes (improvement: 60% ⬇️)
- **Manual Steps:** Automated end-to-end

### 📸 Architecture Diagram
<div align="center">
  <img src="media/Docker-ECS/End-to-End_DevSecOps_CICD_Pipeline.png" alt="Phase 4.2 Architecture" width="600"/>
  <p><i>Figure 5: End-to-End DevSecOps Pipeline from Code to Fargate</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 4.2 Documentation →](4.2-ECS-Fargate-GitHub-Actions/README.md)**
- **[Terraform Code →](4.2-ECS-Fargate-GitHub-Actions/terraform/)**
- **[GitHub Actions Workflow →](.github/workflows/4.2-ECS-CICD.yml)**

---

## 🎮 Phase 5.1: Self-Managed Kubernetes on EC2

**Goal:** Deep dive into Kubernetes internals by building a cluster from scratch.

### What You'll Learn
- ✅ Kubernetes architecture and components
- ✅ Control plane and worker node setup
- ✅ CNI (Container Network Interface) setup
- ✅ Etcd, kubelet, and API server configuration
- ✅ High availability and disaster recovery
- ✅ Production troubleshooting at scale

### Key Highlights
- **Implementation:** Manual cluster creation using `kubeadm` on EC2 instances
- **Networking:** Calico CNI for pod networking and MetalLB for LoadBalancing services
- **Control:** Manual management of Control Plane, Etcd, and Worker Nodes
- **Key Learning:** Understanding the complexities of upgrades, HA, and networking
- **Deployment Time:** 25 minutes
- **Complexity:** High (but invaluable for K8s understanding)

### 📸 Architecture Diagram
<div align="center">
  <img src="media/k8s/strata_ops_k8s_architecture (1).png" alt="Phase 5.1 Architecture" width="600"/>
  <p><i>Figure 6: Self-Managed Kubernetes Architecture with Networking Components</i></p>
</div>

### 🔗 Resources
- **[📖 Full Phase 5.1 Documentation →](5.1-Self-Managed-Kubernetes-on-EC2/README.md)**
- **[Terraform Code →](5.1-Self-Managed-Kubernetes-on-EC2/terraform/)**
- **[Kubeadm Setup Scripts →](5.1-Self-Managed-Kubernetes-on-EC2/scripts/)**

---

## 📦 Phase 5.2: Helm Packaging & Templating

**Goal:** Standardize and simplify complex Kubernetes deployments using Package Management.

### What You'll Learn
- ✅ Helm v3 as the Kubernetes Package Manager
- ✅ Chart creation and templating
- ✅ Values management across environments
- ✅ Dependency management
- ✅ Release versioning and rollbacks
- ✅ Helm best practices and patterns

### Key Highlights
- **Tool:** Helm v3 as the Kubernetes Package Manager
- **Features:**
  - Reusable templates for multiple environments (Dev/Prod)
  - Dependency management for databases, caches, and message queues
  - Versioned releases with built-in rollback capabilities
- **Benefit:** "Write once, deploy anywhere" consistency and speed
- **Deployment Time:** 10 minutes
- **Reusability:** 100% across environments

### 📸 Architecture Integration
*(Helm integrates into the Phase 5.1 architecture to manage the application lifecycle)*

### 🔗 Resources
- **[📖 Full Phase 5.2 Documentation →](5.2-Application-Packaging-and-Templating-with-Helm/README.md)**
- **[Helm Chart →](5.2-Application-Packaging-and-Templating-with-Helm/eprofile-chart/)**

---

## 🚀 Phase 6.1: Production EKS with GitOps & OIDC

**Goal:** The ultimate production-ready environment: Secure, Scalable, and Fully Automated.

This phase represents the **pinnacle of the project**, integrating global best practices for enterprise-grade Kubernetes deployments.

### 🔑 Key Features

1. **✅ OIDC Authentication:** Securely link GitHub Actions to AWS IAM without long-lived keys
2. **✅ IRSA (IAM Roles for Service Accounts):** Granular, least-privilege permissions per Pod
3. **✅ Multi-Layer Security:** Checkov (IaC), Kube-score (Manifests), Trivy (Images)
4. **✅ Immutable Tags:** Prevent image tag overwrites in ECR to ensure integrity
5. **✅ Advanced Ingress:** AWS Load Balancer Controller for automatic ALB provisioning
6. **✅ Secrets Management:** Automatic sync of AWS SSM parameters to K8s Secrets via External Secrets Operator

### 🏛️ High-Level Architecture

The complete flow from Developer to End User, showcasing the integration of AWS services and Kubernetes components.

<div align="center">
  <img src="media/EKS/strata_ops_architecture.png" alt="EKS High-Level Architecture" width="700"/>
  <p><i>Figure 7: Comprehensive Production Architecture on AWS EKS</i></p>
</div>

### 🔐 OIDC & IAM Authentication Flow

How GitHub Actions securely assumes an AWS IAM Role without storing secrets.

<div align="center">
  <img src="media/EKS/aws-alb-provisioned.png" alt="OIDC Authentication Flow" width="600"/>
  <p><i>Figure 8: OIDC Provider Trust Relationship and IAM Role Assumption</i></p>
</div>

### 🛡️ Image Security: Immutable Tags

Preventing malicious overwrites of container images in the registry.

<div align="center">
  <img src="media/EKS/aws-ecr-immutable-image-tags.jpg.png" alt="ECR Immutable Tags" width="600"/>
  <p><i>Figure 9: Enabling Immutable Tags in ECR for Supply Chain Security</i></p>
</div>

### 🏗️ Cluster Readiness

Verification of Control Plane health and Node Group status before deployment.

<div align="center">
  <img src="media/EKS/aws-eks-cluster-ready.png" alt="Cluster Ready Status" width="600"/>
  <p><i>Figure 10: Healthy Control Plane and Ready Worker Nodes</i></p>
</div>

### 🔄 CI/CD Pipeline Success

The successful execution of the 3-stage GitHub Actions pipeline.

<div align="center">
  <img src="media/EKS/github-actions-pipeline-success.png" alt="Pipeline Success" width="600"/>
  <p><i>Figure 11: Green Build Status After Passing All Security Gates</i></p>
</div>

### 🕵️ Advanced Security Scanning (SARIF)

Integration of security findings directly into the GitHub Security tab.

<div align="center">
  <img src="media/EKS/github-advanced-security-sarif.png" alt="Security Scan Results" width="600"/>
  <p><i>Figure 12: Vulnerability Reports via SARIF in GitHub Advanced Security</i></p>
</div>

### 🚦 Ingress & Traffic Routing

Automatic provisioning of the Application Load Balancer by the K8s Controller.

<div align="center">
  <img src="media/EKS/kubectl-pods-ingress-status.png" alt="Ingress Controller Status" width="600"/>
  <p><i>Figure 13: ALB Controller Provisioning and Ingress Resource Status</i></p>
</div>

### 🌐 Application Live on EKS

The moment of truth: Accessing the application via the public internet.

<div align="center">
  <img src="media/EKS/vprofile-app-live-on-eks.png" alt="Application Live" width="600"/>
  <p><i>Figure 14: VProfile Application Successfully Running on EKS</i></p>
</div>

### 🔑 Login Verification

Testing authentication flows and database connectivity.

<div align="center">
  <img src="media/EKS/login-vprofile-app-live-on-eks.png" alt="Login Test" width="600"/>
  <p><i>Figure 15: Successful User Authentication via RDS Backend</i></p>
</div>

### ⚡ Caching Layer Performance

Verifying Memcached integration for session and data caching.

<div align="center">
  <img src="media/EKS/cache-vprofile-app-live-on-eks.png" alt="Cache Test" width="600"/>
  <p><i>Figure 16: Memcached Integration and Performance Verification</i></p>
</div>

### 💾 Data Consistency Check

Ensuring end-to-end data integrity across the application stack.

<div align="center">
  <img src="media/EKS/data-from-cache-vprofile-app-live-on-eks.png" alt="Data Consistency" width="600"/>
  <p><i>Figure 17: End-to-End Data Retrieval and Consistency Check</i></p>
</div>

### 📊 Phase 6.1 Metrics

| Metric | Value |
|--------|-------|
| **EKS Version** | 1.29 |
| **Node Group Size** | 2-4 nodes (auto-scaling) |
| **Pipeline Jobs** | 3 (Security → Build → Deploy) |
| **Security Scanners** | 3 (Checkov, Kube-score, Trivy) |
| **Deployment Time** | ~3 minutes (end-to-end) |
| **Manual Steps** | 0 (Full GitOps) |
| **Hardcoded Credentials** | 0 (OIDC-based) |
| **Containers Deployed** | 5 (App, DB, Cache, Queue, Web) |

### 🔗 Resources
- **[📖 Full Phase 6.1 Documentation & Commands →](6.1-EKS-Provisioning-with-Push-Based-CICD/README.md)**
- **[Terraform Configuration →](6.1-EKS-Provisioning-with-Push-Based-CICD/terraform/)**
- **[Helm Chart →](6.1-EKS-Provisioning-with-Push-Based-CICD/eprofile-chart/)**
- **[GitHub Actions Workflow →](.github/workflows/6.1-EKS-CICD.yml)**

### Quick Start
```bash
cd 6.1-EKS-Provisioning-with-Push-Based-CICD

# 1. Provision EKS cluster
terraform init
terraform plan
terraform apply

# 2. Configure kubectl
aws eks update-kubeconfig --name strata-eks-cluster --region eu-central-1

# 3. Deploy application via Helm
helm upgrade --install vproapp ./eprofile-chart --wait

# 4. Verify deployment
kubectl get pods
kubectl get ingress
```

---

## 📈 Performance & Cost Comparison

How did key metrics evolve across the phases?

### ⏱️ Deployment Time Evolution

| Phase | Deployment Time | Improvement | Key Factor |
| :--- | :--- | :--- | :--- |
| **Phase 1** (Local Manual) | 45-60 mins | - | Manual everything |
| **Phase 2** (Jenkins EC2) | ~20 mins | 55% ⬇️ | Infrastructure automation |
| **Phase 3** (CodePipeline) | ~15 mins | 67% ⬇️ | Managed services |
| **Phase 4.1** (Docker Compose) | ~12 mins | 73% ⬇️ | Containerization |
| **Phase 4.2** (ECS Fargate) | ~8 mins | 82% ⬇️ | Serverless compute |
| **Phase 5.1** (Self-Managed K8s) | ~25 mins | High complexity | Learning overhead |
| **Phase 5.2** (Helm) | ~10 mins | 78% ⬇️ | Template-based |
| **Phase 6.1** (EKS GitOps) | **~3 mins** | **93% ⬇️** | **Full automation + push** |

### 🔒 Manual Steps Reduction

| Phase | Manual Steps | Automation Level | Dependency |
| :--- | :--- | :--- | :--- |
| Phase 1 | 15+ Steps | Fully Manual | 0% |
| Phase 2 | 8 Steps | Semi-Automated | 40% |
| Phase 3 | 5 Steps | Mostly Automated | 70% |
| Phase 4.1 | 6 Steps | Docker-driven | 60% |
| Phase 4.2 | 2 Steps | CI/CD-driven | 95% |
| Phase 5.1 | 8 Steps | Complex Manual | 50% |
| Phase 5.2 | 2 Steps | Helm-templated | 90% |
| **Phase 6.1** | **0 Steps** | **Full GitOps** | **100%** |

### 💰 Monthly Cost Estimate (Dev Environment)
*Costs are approximate based on `eu-central-1` region.*

| Phase | Monthly Cost | Components | Notes |
| :--- | :--- | :--- | :--- |
| Phase 1 | $0 | Local resources | Development only |
| Phase 2 | ~$60/mo | EC2 (fixed) | Always running |
| Phase 3 | ~$45/mo | Elastic Beanstalk | Managed, still expensive |
| Phase 4.1 | $0 | Local Docker | Development only |
| Phase 4.2 | ~$35/mo | Fargate + ECR | Pay-per-use |
| Phase 5.1 | ~$50/mo | EC2 nodes | Still manual overhead |
| Phase 5.2 | ~$50/mo | EC2 nodes | No cost reduction |
| **Phase 6.1** | **~$75/mo** | **EKS ($72 + nodes)** | **Production-grade, scales better** |

**Cost Analysis:**
- ✅ EKS is higher in cost but includes managed control plane ($72), CloudWatch logs, and auto-scaling capabilities
- ✅ Better for production due to HA, security features (IRSA, OIDC), and multi-AZ distribution
- ✅ Fargate is most cost-efficient for simple workloads, but lacks Kubernetes portability
- ✅ Self-managed K8s requires significant ops overhead (not reflected in compute cost)

---

## 🛡️ Best Practices & Lessons Learned

### 1. Infrastructure as Code (IaC)

✅ **State Locking:** Always use Terraform State Locking (e.g., via S3 + DynamoDB) to prevent concurrent modification conflicts.

```hcl
terraform {
  backend "s3" {
    bucket         = "strata-ops-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

✅ **Modularity:** Break code into reusable modules (Network, DB, App, K8s) for maintainability.

```
terraform/
├── modules/
│   ├── networking/
│   ├── eks/
│   ├── ecr/
│   └── rds/
└── main.tf
```

---

### 2. Security (DevSecOps)

✅ **Shift Left:** Scan for vulnerabilities early:
- **Checkov** (IaC scanning) — Detect misconfigurations before infrastructure exists
- **Kube-score** (K8s manifests) — Validate security best practices in YAML
- **Trivy** (Container images) — Scan for CVEs before pushing to registry

✅ **Least Privilege:** Use IRSA (IAM Roles for Service Accounts) in EKS to grant permissions only to specific Pods, not the whole node.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vproapp
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/vproapp-role
```

✅ **No Hardcoded Secrets:** Never commit secrets. Use:
- **AWS Secrets Manager** with External Secrets Operator
- **AWS Parameter Store** with automatic K8s Secret sync
- **GitHub Secrets** for CI/CD credentials (encrypted at rest)

---

### 3. Kubernetes Orchestration

✅ **Managed > Self-Managed:** Use EKS for production to avoid the heavy lift of managing the Control Plane.

| Aspect | Self-Managed (Phase 5.1) | EKS (Phase 6.1) |
|--------|----------------------|-----------------|
| Control Plane | You manage | AWS manages |
| Updates | Manual, risky | Automated, rolling |
| High Availability | Complex setup | Built-in |
| Cost | Higher ops overhead | Higher compute cost |
| Learning | Invaluable | Production-ready |

✅ **Helm is Mandatory:** Avoid raw `kubectl apply` in production. Use Helm for:
- Versioning and release management
- Built-in rollback capabilities
- Environment-specific values (dev/prod)
- Dependency management

✅ **Resource Limits:** Always define `requests` and `limits` for CPU/RAM to prevent resource starvation.

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

---

### 4. CI/CD Engineering

✅ **Ephemeral Runners:** Prefer GitHub Actions runners over persistent Jenkins servers for:
- Better security (no long-lived infrastructure)
- Lower cost (pay-per-execution)
- Easier maintenance (no VM to manage)

✅ **Immutable Artifacts:** Never rebuild the same tag. Use:
- Git SHA tags for full traceability
- Semantic versioning for releases
- Immutable tags in ECR to prevent overwrites

```yaml
- name: Push to ECR
  run: |
    docker tag vproapp:${{ github.sha }} $ECR_REGISTRY/$ECR_REPOSITORY:${{ github.sha }}
    docker push $ECR_REGISTRY/$ECR_REPOSITORY:${{ github.sha }}
```

✅ **Secrets Rotation:** Use OIDC for temporary credentials instead of long-lived keys.

---

### 5. Observability & Monitoring

✅ **Multi-Layer Observability:**
- **Metrics**: Prometheus/CloudWatch for infrastructure and application health
- **Logs**: Centralized logging (CloudWatch Logs, ELK, Datadog)
- **Traces**: Distributed tracing (X-Ray, Jaeger) for request flows
- **Alerts**: Automated alerting with SNS/PagerDuty

✅ **Key Metrics to Monitor:**
- Pod restart counts (stability indicator)
- Node resource utilization (scaling trigger)
- Application error rates (health indicator)
- Deployment success rate (pipeline health)

---

### 6. Cost Optimization

✅ **Right-Sizing:**
- Use Compute Optimizer recommendations
- Monitor actual vs. requested resources
- Scale down during non-business hours

✅ **Spot Instances:** Use AWS Spot Instances for non-critical workloads (up to 70% savings).

✅ **Reserved Instances:** Purchase RIs for predictable production workloads.

---

## 📂 Repository Structure

```text
Strata-Ops/
│
├── README.md                                        # 📍 Master Documentation (This File)
│
├── 1-Local-Foundation/                              # Phase 1: VirtualBox & Vagrant Setup
│   ├── 1.1-Local-Setup-Manual/
│   │   ├── README.md
│   │   └── Vagrantfile
│   │
│   └── 1.2-Local-Setup-Automated-Vagrand/
│       ├── README.md
│       ├── Vagrantfile
│       ├── mysql.sh
│       ├── memcache.sh
│       ├── rabbitmq.sh
│       ├── tomcat_ubuntu.sh
│       └── nginx.sh
│
├── 2-AWS-Lift-And-Shift/                            # Phase 2: EC2, Jenkins, Terraform
│   ├── README.md
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── vpc.tf
│   │   ├── security_groups.tf
│   │   ├── asg.tf
│   │   ├── rds.tf
│   │   └── variables.tf
│   └── jenkins/
│       └── Jenkinsfile
│
├── 3-Cloud-Native-PaaS/                             # Phase 3: Elastic Beanstalk, CodePipeline
│   ├── README.md
│   ├── cloudformation/
│   │   └── beanstalk-template.yaml
│   └── buildspec.yml
│
├── 4.1-Docker-Compose-Ansible/                      # Phase 4.1: Containerization & Ansible
│   ├── README.md
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── ansible/
│   │   ├── playbook.yml
│   │   └── roles/
│   └── .dockerignore
│
├── 4.2-ECS-Fargate-GitHub-Actions/                  # Phase 4.2: Serverless Containers
│   ├── README.md
│   ├── terraform/
│   │   ├── ecs.tf
│   │   ├── ecr.tf
│   │   ├── alb.tf
│   │   └── variables.tf
│   └── .github/workflows/
│       └── 4.2-ECS-CICD.yml
│
├── 5.1-Self-Managed-Kubernetes-on-EC2/              # Phase 5.1: Deep Dive K8s
│   ├── README.md
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── security_groups.tf
│   │   └── variables.tf
│   ├── scripts/
│   │   ├── master-setup.sh
│   │   ├── worker-setup.sh
│   │   └── network-setup.sh
│   └── manifests/
│       └── application.yaml
│
├── 5.2-Application-Packaging-and-Templating-with-Helm/  # Phase 5.2: Helm Charts
│   ├── README.md
│   └── eprofile-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-prod.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── configmap.yaml
│           └── _helpers.tpl
│
├── 6.1-EKS-Provisioning-with-Push-Based-CICD/       # Phase 6.1: Production EKS
│   ├── README.md
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── eks.tf
│   │   ├── iam.tf
│   │   ├── ecr.tf
│   │   ├── alb.tf
│   │   ├── oidc.tf
│   │   └── variables.tf
│   ├── eprofile-chart/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── ingress.yaml
│   │       ├── configmap.yaml
│   │       ├── serviceaccount.yaml
│   │       └── _helpers.tpl
│   └── scripts/
│       ├── setup-oidc.sh
│       └── deploy.sh
│
├── .github/
│   └── workflows/
│       ├── 4.2-ECS-CICD.yml
│       └── 6.1-EKS-CICD.yml
│
├── media/                                           # 🖼️ Architecture Diagrams & Screenshots
│   ├── Lift-shift/
│   │   ├── local-arch.png
│   │   └── lift-shift-arch.png
│   ├── cloud-native/
│   │   └── cloud-native-arch.png
│   ├── Docker-compose/
│   │   └── docker-compose-arch.png
│   ├── Docker-ECS/
│   │   └── End-to-End_DevSecOps_CICD_Pipeline.png
│   ├── k8s/
│   │   └── strata_ops_k8s_architecture.png
│   └── EKS/
│       ├── strata_ops_architecture.png
│       ├── aws-alb-provisioned.png
│       ├── aws-ecr-immutable-image-tags.jpg.png
│       ├── aws-eks-cluster-ready.png
│       ├── github-actions-pipeline-success.png
│       ├── github-advanced-security-sarif.png
│       ├── kubectl-pods-ingress-status.png
│       ├── vprofile-app-live-on-eks.png
│       ├── login-vprofile-app-live-on-eks.png
│       ├── cache-vprofile-app-live-on-eks.png
│       └── data-from-cache-vprofile-app-live-on-eks.png
│
└── .gitignore                                       # Version control exclusions

```

---

## 🎓 What This Demonstrates

### **Infrastructure Engineering**
- Manual to fully automated provisioning progression
- Multi-tier VPC design with network isolation
- Managed vs. self-hosted trade-off analysis
- Serverless compute with ECS Fargate
- Managed Kubernetes (EKS) at enterprise scale
- Infrastructure as Code with Terraform (100% reproducible)

### **DevSecOps**
- Shift-left security with vulnerability scanning before every build
- Zero hardcoded credentials across all phases using AWS Secrets Manager
- SARIF integration with GitHub Advanced Security dashboard
- Multi-layer scanning: IaC (Checkov), Manifests (Kube-score), Images (Trivy)
- OIDC-based authentication (temporary, rotated credentials)
- Immutable container image tags for supply chain security

### **CI/CD Engineering**
- Jenkins with JCasC (entire state in version control)
- AWS CodePipeline with quality gates blocking bad code
- GitHub Actions with runtime SSM parameter fetching
- Pipeline-owned secrets (never in code)
- Multi-stage deployments with automatic rollback
- Health checks and smoke tests before production

### **Observability**
- Prometheus + Grafana for infrastructure metrics
- CloudWatch + SNS for managed platform alerts
- Datadog full-stack with APM traces + JVM metrics + log routing
- Application-level metrics (response time, error rates, throughput)
- Infrastructure-level metrics (CPU, memory, disk, network)
- Distributed tracing across all microservices

### **Container Engineering**
- Multi-stage Docker builds for optimized images
- Health-aware container dependency chains
- Sidecar pattern for observability injection
- Shared unix socket volumes for inter-container APM communication
- Container registry best practices (immutable tags, scanning)
- Network policies and service mesh basics

---

## 📖 Getting Started

### New to DevOps?
Start with **Phase 1** → **Phase 2** → **Phase 3** for foundational understanding.

### Interested in Kubernetes?
Go **Phase 4.1** → **Phase 5.1** → **Phase 5.2** → **Phase 6.1** for K8s progression.

### Want Production-Ready?
Jump to **Phase 6.1** (but understand the foundation first).

### Container-First Approach?
Start **Phase 4.1** → **Phase 4.2** → **Phase 6.1** (skipping traditional infrastructure).

---

## 🤝 Contributing

This project is open for:
- 🐛 Bug reports and fixes
- 📝 Documentation improvements
- 🎨 Architecture diagram updates
- 🔍 Security enhancements
- ✨ Additional phase implementations (6.2: ArgoCD, Phase 7: Multi-cloud)

---

## 📝 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

---

<div align="center">

---

*Each phase is a complete, deployable, production-grade system.*  
*Each layer builds on everything that came before it.*  
*This is how infrastructure expertise is built — from the core up.*

---

## 🌋 Strata-Ops

**Built layer by layer by [Amr Medhat Amer](https://github.com/amramer101)**

[![GitHub](https://img.shields.io/badge/GitHub-amramer101%2FStrata--Ops-181717?style=for-the-badge&logo=github)](https://github.com/amramer101/Strata-Ops)
[![Email](https://img.shields.io/badge/Email-Connect-0078D4?style=for-the-badge&logo=microsoft-outlook)](mailto:your-email@example.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/your-profile/)

**Last Updated:** 2026-04-29  
**Status:** Production Ready ✅

</div>
