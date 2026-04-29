# 🚀 Strata-Ops: The Ultimate DevSecOps Evolution Journey

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stage](https://img.shields.io/badge/Stage-Production%20Ready-brightgreen)](https://github.com/amr-shalaby/Strata-Ops)
[![Terraform](https://img.shields.io/badge/Terraform-v1.6+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/K8s-v1.28-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS%2FECR%2FRDS-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Security](https://img.shields.io/badge/Security-DevSecOps%20Shift--Left-red?logo=owasp)](https://owasp.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)

> **🎯 Mission:** To document a complete engineering transformation of the `VProfile` application. This journey evolves from a simple local virtualized environment to a **production-grade, cloud-native Kubernetes architecture on AWS EKS**, implementing **GitOps**, **Zero-Trust Security**, **OIDC Authentication**, and **Infrastructure as Code (IaC)**.

---

## 📑 Table of Contents

1. [🗺️ Project Roadmap & Evolution](#-project-roadmap--evolution)
2. [🏗️ Phase 1: Local Foundation](#-phase-1-local-foundation)
3. [☁️ Phase 2: AWS Lift & Shift](#-phase-2-aws-lift--shift)
4. [🌩️ Phase 3: Cloud-Native PaaS](#-phase-3-cloud-native-paas)
5. [🐳 Phase 4.1: Containerization & Ansible](#-phase-41-containerization--ansible)
6. [⚡ Phase 4.2: Serverless Containers (ECS Fargate)](#-phase-42-serverless-containers-ecs-fargate)
7. [🎮 Phase 5.1: Self-Managed Kubernetes](#-phase-51-self-managed-kubernetes-on-ec2)
8. [📦 Phase 5.2: Helm Packaging & Templating](#-phase-52-helm-packaging--templating)
9. [🚀 Phase 6.1: Production EKS with GitOps](#-phase-61-production-eks-with-gitops--oidc)
10. [📊 Performance & Cost Comparison](#-performance--cost-comparison)
11. [🛡️ Best Practices & Lessons Learned](#-best-practices--lessons-learned)

---

## 🗺️ Project Roadmap & Evolution

This repository represents more than just code migration; it is an evolution of **Engineering Mindset**:

| Phase | Platform | Deployment Strategy | Security Posture | Observability | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | VirtualBox (Local) | Manual (SSH/SCP) | Basic SSH Keys | Log Files | ✅ Complete |
| **2** | AWS EC2 (IaaS) | Jenkins Pipeline | Security Groups | Grafana/Prometheus | ✅ Complete |
| **3** | Elastic Beanstalk | AWS CodePipeline | WAF + Secrets Mgr | CloudWatch | ✅ Complete |
| **4.1** | Docker Compose | Ansible Playbooks | Container Linting | Docker Stats | ✅ Complete |
| **4.2** | AWS ECS Fargate | GitHub Actions | Trivy + Checkov | Datadog APM | ✅ Complete |
| **5.1** | Self-Managed K8s | Kubeadm (Manual) | Network Policies | Metrics Server | ✅ Complete |
| **5.2** | Kubernetes (Helm) | Helm Charts | RBAC + Secrets | Prometheus Stack | ✅ Complete |
| **6.1** | **AWS EKS (Prod)** | **GitOps (OIDC)** | **IRSA + Immutable Tags** | **CloudWatch + X-Ray** | ✅ **Live** |

---

## 🏗️ Phase 1: Local Foundation
**Goal:** Establish a baseline local environment to understand the 3-Tier Architecture components.
- **Infrastructure:** 3 VMs (App, DB, LB) provisioned via Vagrant & VirtualBox.
- **Challenge:** Manually managing version compatibility (Java, Tomcat, MySQL).
- **Outcome:** A functioning local application ready for cloud migration.

📸 **Architecture:**
<div align="center">
  <img src="media/Lift-shift/local-arch.png" alt="Phase 1 Architecture" width="600"/>
  <p><i>Figure 1: Basic Local Virtualized 3-Tier Architecture</i></p>
</div>

🔗 **[📖 Read Full Phase 1 Documentation →](1-Local-Foundation/README.md)**

---

## ☁️ Phase 2: AWS Lift & Shift
**Goal:** Migrate to AWS IaaS while automating infrastructure provisioning (IaC).
- **Infrastructure:** EC2 Instances within an Auto Scaling Group managed by Terraform.
- **Database:** Migration to Amazon RDS (MySQL) for managed backups and high availability.
- **CI/CD:** Implementation of a Jenkins Pipeline for automated WAR building and deployment.
- **Observability:** Grafana and Prometheus setup for real-time metric visualization.

📸 **Architecture:**
<div align="center">
  <img src="media/Lift-shift/lift-shift-arch.png" alt="Phase 2 Architecture" width="600"/>
  <p><i>Figure 2: Lift & Shift Architecture on EC2 with RDS and Jenkins</i></p>
</div>

🔗 **[📖 Read Full Phase 2 Documentation →](2-AWS-Lift-And-Shift/README.md)**

---

## 🌩️ Phase 3: Cloud-Native PaaS
**Goal:** Reduce operational overhead by leveraging AWS Platform-as-a-Service.
- **Platform:** AWS Elastic Beanstalk for abstracted application hosting.
- **CI/CD:** AWS CodePipeline for seamless integration with source control.
- **Security:** Integration of AWS WAF and Secrets Manager for credential management.
- **Benefit:** Focus shifts entirely to code development rather than server management.

📸 **Architecture:**
<div align="center">
  <img src="media/cloud-native/cloud-native-arch.png" alt="Phase 3 Architecture" width="600"/>
  <p><i>Figure 3: Fully Managed PaaS Architecture with CodePipeline</i></p>
</div>

🔗 **[📖 Read Full Phase 3 Documentation →](3-Cloud-Native-PaaS/README.md)**

---

## 🐳 Phase 4.1: Containerization & Ansible
**Goal:** Decouple applications from infrastructure using Docker and ensure environment consistency.
- **Technology:** Docker Compose for multi-container orchestration locally.
- **Configuration:** Ansible playbooks for automated server provisioning and configuration.
- **Benefit:** Elimination of "It works on my machine" issues through containerization.

📸 **Architecture:**
<div align="center">
  <img src="media/Docker-compose/docker-compose-arch.png" alt="Phase 4.1 Architecture" width="600"/>
  <p><i>Figure 4: Local Containerized Architecture with Ansible Configuration</i></p>
</div>

🔗 **[📖 Read Full Phase 4.1 Documentation →](4.1-Docker-Compose-Ansible/README.md)**

---

## ⚡ Phase 4.2: Serverless Containers (ECS Fargate)
**Goal:** Run containers without managing servers, integrated with a modern CI/CD pipeline.
- **Platform:** AWS ECS Fargate (Serverless Compute).
- **CI/CD:** GitHub Actions with integrated security scanning (Trivy, Checkov).
- **Observability:** Datadog APM integration for distributed tracing and deep insights.
- **Network:** Service Mesh implementation for secure service-to-service communication.

📸 **Architecture:**
<div align="center">
  <img src="media/Docker-ECS/End-to-End_DevSecOps_CICD_Pipeline.png" alt="Phase 4.2 Architecture" width="600"/>
  <p><i>Figure 5: End-to-End DevSecOps Pipeline from Code to Fargate</i></p>
</div>

🔗 **[📖 Read Full Phase 4.2 Documentation →](4.2-ECS-Fargate-GitHub-Actions/README.md)**

---

## 🎮 Phase 5.1: Self-Managed Kubernetes on EC2
**Goal:** Deep dive into Kubernetes internals by building a cluster from scratch.
- **Implementation:** Manual cluster creation using `kubeadm` on EC2 instances.
- **Networking:** Calico CNI for pod networking and MetalLB for LoadBalancing services.
- **Control:** Manual management of Control Plane, Etcd, and Worker Nodes.
- **Key Learning:** Understanding the complexities of upgrades, high availability, and networking.

📸 **Architecture:**
<div align="center">
  <img src="media/k8s/strata_ops_k8s_architecture (1).png" alt="Phase 5.1 Architecture" width="600"/>
  <p><i>Figure 6: Self-Managed Kubernetes Architecture with Networking Components</i></p>
</div>

🔗 **[📖 Read Full Phase 5.1 Documentation →](5.1-Self-Managed-Kubernetes-on-EC2/README.md)**

---

## 📦 Phase 5.2: Helm Packaging & Templating
**Goal:** Standardize and simplify complex Kubernetes deployments using Package Management.
- **Tool:** Helm v3 as the Kubernetes Package Manager.
- **Features:**
  - Reusable templates for multiple environments (Dev/Prod).
  - Dependency management for databases, caches, and message queues.
  - Versioned releases with built-in rollback capabilities.
- **Benefit:** "Write once, deploy anywhere" consistency and speed.

📸 **Architecture:**
*(Helm integrates into the Phase 5.1 architecture to manage the application lifecycle)*

🔗 **[📖 Read Full Phase 5.2 Documentation →](5.2-Application-Packaging-and-Templating-with-Helm/README.md)**

---

## 🚀 Phase 6.1: Production EKS with GitOps & OIDC
**Goal:** The ultimate production-ready environment: Secure, Scalable, and Fully Automated.
This phase represents the pinnacle of the project, integrating global best practices.

### 🔑 Key Features:
1.  **OIDC Authentication:** Securely link GitHub Actions to AWS IAM without long-lived keys.
2.  **IRSA (IAM Roles for Service Accounts):** Granular, least-privilege permissions per Pod.
3.  **Multi-Layer Security:** Checkov (IaC), Kube-score (Manifests), Trivy (Images).
4.  **Immutable Tags:** Prevent image tag overwrites in ECR to ensure integrity.
5.  **Advanced Ingress:** AWS Load Balancer Controller for automatic ALB provisioning.
6.  **Secrets Management:** Automatic sync of AWS SSM parameters to K8s Secrets via External Secrets Operator.

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

🔗 **[📖 Read Full Phase 6.1 Documentation & Commands →](6.1-EKS-Provisioning-with-Push-Based-CICD/README.md)**

---

## 📊 Performance & Cost Comparison

How did key metrics evolve across the phases?

### ⏱️ Deployment Time Evolution
| Phase | Approx. Time | Improvement |
| :--- | :--- | :--- |
| Phase 1 (Local) | 45+ mins | - |
| Phase 2 (Jenkins) | 20 mins | 55% ⬇️ |
| Phase 4.2 (ECS) | 8 mins | 60% ⬇️ |
| **Phase 6.1 (EKS)** | **3 mins** | **62% ⬇️** |

### 🔒 Manual Steps Reduction
| Phase | Manual Steps | Automation Level |
| :--- | :--- | :--- |
| Phase 1 | 15+ Steps | Fully Manual |
| Phase 3 | 5 Steps | Semi-Automated |
| Phase 5.1 | 8 Steps | Complex Manual |
| **Phase 6.1** | **0 Steps** | **Full GitOps** |

### 💰 Monthly Cost Estimate (Dev Environment)
*Note: Costs are approximate based on `eu-central-1` region.*
- **Phase 2 (EC2):** ~$60/mo (Fixed cost even when idle).
- **Phase 4.2 (Fargate):** ~$35/mo (Pay-per-use efficiency).
- **Phase 6.1 (EKS):** ~$75/mo (Includes $72 Control Plane + Nodes).
  - *Justification:* Higher cost for EKS is justified by production-grade reliability, advanced security (IRSA/OIDC), and infinite scalability.

---

## 🛡️ Best Practices & Lessons Learned

### 1. Infrastructure as Code (IaC)
- ✅ **State Locking:** Always use Terraform State Locking (e.g., via S3 + DynamoDB) to prevent concurrent modification conflicts.
- ✅ **Modularity:** Break code into reusable modules (Network, DB, App) for maintainability.

### 2. Security (DevSecOps)
- ✅ **Shift Left:** Scan for vulnerabilities early: Checkov (IaC), Kube-score (Manifests), Trivy (Images).
- ✅ **Least Privilege:** Use IRSA in EKS to grant permissions only to specific Pods, not the whole node.
- ✅ **No Hardcoded Secrets:** Never commit secrets. Use External Secrets Operator or AWS Secrets Manager.

### 3. Kubernetes Orchestration
- ✅ **Managed > Self-Managed:** Use EKS for production to avoid the heavy lift of managing the Control Plane.
- ✅ **Helm is Mandatory:** Avoid raw `kubectl apply` in production. Use Helm for versioning and rollbacks.
- ✅ **Resource Limits:** Always define `requests` and `limits` for CPU/RAM to prevent resource starvation.

### 4. CI/CD Engineering
- ✅ **Ephemeral Runners:** Prefer GitHub Actions runners over persistent Jenkins servers for security and cost.
- ✅ **Immutable Artifacts:** Never rebuild the same tag. Use unique SHA tags or semantic versioning.

---

## 📂 Repository Structure

```text
Strata-Ops/
├── README.md                   # 📍 Master Documentation (This File)
├── 1-Local-Foundation/         # VirtualBox & Vagrant Setup
├── 2-AWS-Lift-And-Shift/       # EC2, Jenkins, Terraform
├── 3-Cloud-Native-PaaS/        # Elastic Beanstalk, CodePipeline
├── 4.1-Docker-Compose-Ansible/ # Containerization Basics
├── 4.2-ECS-Fargate-GitHub-Actions/ # Serverless Containers
├── 5.1-Self-Managed-Kubernetes-on-EC2/ # Deep Dive K8s
├── 5.2-Application-Packaging-and-Templating-with-Helm/ # Helm Charts
├── 6.1-EKS-Provisioning-with-Push-Based-CICD/ # Production EKS
└── media/                      # 🖼️ Architecture Diagrams & Screenshots
    ├── Lift-shift/
    ├── cloud-native/
    ├── Docker-compose/
    ├── Docker-ECS/
    ├── k8s/
    └── EKS/                    # Production Phase Assets


## What This Demonstrates

**Infrastructure Engineering** — Manual to fully automated provisioning, multi-tier VPC design with network isolation, managed vs. self-hosted trade-off analysis, serverless compute with ECS Fargate.

**DevSecOps** — Shift-left security with vulnerability scanning before every build, zero hardcoded credentials across all phases using SSM as the pattern, SARIF integration with GitHub Advanced Security, IaC security scanning with tfsec.

**CI/CD Engineering** — Jenkins JCasC with entire state in version control, AWS CodePipeline with quality gates blocking bad code, GitHub Actions with runtime SSM parameter fetching, pipeline-owned image updates with Terraform `ignore_changes`.

**Observability** — Prometheus + Grafana for infrastructure metrics, CloudWatch + SNS for managed platform alerts, Datadog full-stack with APM traces + JVM metrics + log routing via Firelens sidecar.

**Container Engineering** — Multi-stage Docker builds, health-aware container dependency chains, sidecar pattern for observability, shared unix socket volumes for inter-container APM communication.

---

<div align="center">

---

*Each phase is a complete, deployable, production-grade system.*
*Each layer builds on everything that came before it.*
*This is how infrastructure expertise is built — from the core up.*

---

**🌋 Strata-Ops — Built layer by layer by [Amr Medhat Amer](https://github.com/amramer101)**

[![GitHub](https://img.shields.io/badge/GitHub-amramer101%2FStrata--Ops-181717?style=for-the-badge&logo=github)](https://github.com/amramer101/Strata-Ops)

</div>