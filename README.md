# 🌋 Strata-Ops

<div align="center">

### *A Complete DevOps Engineering Journey — From Bare Metal to Cloud-Native*

> One application. Five deployment strategies. Production-grade engineering at every layer.

[![Java](https://img.shields.io/badge/Java-Maven-ED8B00?style=for-the-badge&logo=openjdk)](https://openjdk.org/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?style=for-the-badge&logo=github-actions)](https://github.com/features/actions)
[![Datadog](https://img.shields.io/badge/Datadog-Observability-632CA6?style=for-the-badge&logo=datadog)](https://www.datadoghq.com/)

**Built by [Amr Medhat Amer](https://github.com/amramer101) — Cloud & DevSecOps Engineer**

</div>

---

## What Is Strata-Ops?

**Strata-Ops** is a production-grade DevOps engineering project that takes a 5-tier Java application through five distinct deployment evolutions — each one more automated, more scalable, and more observable than the last.

Like geological strata, every layer is built on top of the previous one. You cannot understand the cloud without understanding the metal. You cannot automate what you have not done manually. You cannot containerize what you have not first deployed on VMs.

This is not a tutorial. This is an engineering portfolio.

---

## The Application

A production-grade **5-tier Java web application** running consistently across all phases:

```
┌──────────────────────────────────────────────────────┐
│                  NGINX  :80                          │
│            Reverse Proxy / Frontend Gateway          │
└────────────────────┬─────────────────────────────────┘
                     │
┌────────────────────▼─────────────────────────────────┐
│              TOMCAT  :8080                           │
│         Java Application Server (Spring MVC)         │
└──────┬──────────────┬──────────────────┬─────────────┘
       │              │                  │
       ▼ :3306        ▼ :11211           ▼ :5672
  ┌─────────┐   ┌───────────┐   ┌──────────────┐
  │  MySQL  │   │ Memcached │   │   RabbitMQ   │
  │Database │   │  Cache    │   │Message Queue │
  └─────────┘   └───────────┘   └──────────────┘
```

**Same stack. Every phase. Different infrastructure. Complete mastery.**

---

## The Journey: Five Evolutionary Layers

```
                    🌋 THE SUMMIT
          ┌───────────────────────────────┐
          │  Phase 4.2 — ECS Fargate      │
          │  Docker + GitHub Actions +    │
          │  Terraform + Datadog APM      │
          │  Serverless · GitOps · Observed│
          └──────────────┬────────────────┘
                         │
          ┌──────────────▼────────────────┐
          │  Phase 4.1 — Docker Compose   │
          │  Containers + Ansible +       │
          │  EC2 Single Host Deployment   │
          │  Containerized · Automated    │
          └──────────────┬────────────────┘
                         │
          ┌──────────────▼────────────────┐
          │  Phase 3 — Cloud-Native PaaS  │
          │  Beanstalk + CodePipeline +   │
          │  SonarCloud + TruffleHog      │
          │  Managed · Secure · CI/CD     │
          └──────────────┬────────────────┘
                         │
          ┌──────────────▼────────────────┐
          │  Phase 2 — AWS Lift & Shift   │
          │  EC2 + Terraform + Jenkins +  │
          │  Prometheus + Grafana         │
          │  Cloud · Automated · Observed │
          └──────────────┬────────────────┘
                         │
          ┌──────────────▼────────────────┐
          │  Phase 1 — Local Foundation   │
          │  VirtualBox + Vagrant         │
          │  Manual then Automated        │
          │  Understanding from scratch   │
          └───────────────────────────────┘
                    🌋 THE CORE
```

---

## Phase 1 — The Inner Core: Local Foundation

> *Before you can automate infrastructure, you must understand it intimately.*

**Directory:** `1.1-Local-Setup-Manual/` and `1.2-Local-Setup-Automated-Vagrand/`

### What Was Built

5 virtual machines on a local laptop, manually provisioned from scratch — no automation, no shortcuts. Every service installed, configured, and connected by hand. Then the entire process was codified into shell scripts and Vagrant automation.

### The Manual Setup

```
Phase 1a — Manual Provisioning
Setup Sequence (Order Critical):

1. MySQL (db01)
   └── MariaDB install → root password → create accounts DB
   └── Import db_backup.sql from GitHub
   └── Open firewall port 3306

2. Memcached (mc01)
   └── Install → configure to listen on 0.0.0.0
   └── Open firewall port 11211

3. RabbitMQ (rmq01)
   └── Install → create test user → set permissions
   └── Open firewall port 5672

4. Tomcat (app01)
   └── Install Java 17 + Tomcat 10
   └── Clone repo → Maven build → deploy WAR

5. Nginx (web01)
   └── Install → configure reverse proxy → restart
```

### The Automated Setup

```
Phase 1b — Vagrant Automated Provisioning

vagrant up
    │
    ├── db01  → mysql.sh      (same steps, scripted)
    ├── mc01  → memcache.sh
    ├── rmq01 → rabbitmq.sh
    ├── app01 → tomcat_ubuntu.sh
    └── web01 → nginx.sh

45-60 min (manual) → 10-15 min (automated)
50+ commands       → 1 command
```

### Technologies

`VirtualBox` · `Vagrant` · `Bash Scripting` · `MariaDB` · `Tomcat 10` · `Nginx` · `RabbitMQ` · `Memcached`

### Key Lessons

- Service dependencies drive initialization order — Tomcat must start after MySQL, Memcached, and RabbitMQ
- Every manual command maps directly to one line of automation script
- Idempotent scripts are the foundation of reliable infrastructure

| Metric | Manual | Automated |
|--------|--------|-----------|
| Setup Time | 45–60 min | 10–15 min |
| Manual Steps | 50+ | 1 |
| Repeatability | Hard | Perfect |
| Error Rate | High | Near zero |

📖 **[Full Documentation →](1.1-Local-Setup-Manual/README.md)**

---

## Phase 2 — The Outer Core: AWS Lift & Shift + Full Observability Stack

> *Same architecture. Cloud scale. Zero manual steps. Full visibility.*

**Directory:** `2-AWS-Lift-Shift-with-CICD-Monitoring/`

<div align="center">

![Phase 2 Architecture](media/Lift-shift/digram.png)
*10 EC2 instances across 3 tiers — Application, CI/CD, and Monitoring — wired together via Route53 Private DNS and SSM Parameter Store*

</div>

### What Was Built

A complete AWS infrastructure with 10 EC2 instances, a 7-stage CI/CD pipeline with quality gates, and a full Prometheus + Grafana observability stack — all provisioned by a single `terraform apply` command.

### Three Independent Layers

```
LAYER 1 — APPLICATION TIER
  Nginx :80 → Tomcat (app01.eprofile.in) :8080
                  │              │              │
             MySQL:3306    Memcd:11211     RMQ:5672
             (Private Subnet — no public IP, no inbound route)

LAYER 2 — CI/CD PIPELINE (Jenkins JCasC)
  GitHub Push
       │
  Stage 1: mvn test
  Stage 2: OWASP Dependency Check (NVD CVE database)
  Stage 3: SonarQube SAST (24k lines)
  Stage 4: Quality Gate — blocks pipeline on failure
  Stage 5: mvn package → ROOT.war
  Stage 6: Nexus upload (versioned, rollback-ready)
  Stage 7: SSH deploy to Tomcat
  Post:    Slack notification (pass/fail)

LAYER 3 — OBSERVABILITY
  Prometheus → Node Exporter :9100 on all 5 app servers (every 15s)
  Grafana    → auto-provisioned datasource, per-server dashboards
```

### Secrets Architecture — SSM Coordination Bus

```
No password in any committed file.

/strata-ops/mysql-password          ← Terraform auto-generates
/strata-ops/jenkins-admin-password  ← Terraform auto-generates
/strata-ops/nexus-password          ← nexus.sh writes after boot
/strata-ops/sonar-token             ← sonar.sh writes after boot
/strata-ops/tomcat-ssh-key          ← EC2 private key for deploy
/strata-ops/github-private-key      ← SSH key for repo access
/strata-ops/slack-token             ← Slack bot token

Jenkins polls SSM in a wait loop — refuses to start until
Nexus and SonarQube have written their real credentials.
SSM becomes the distributed coordination mechanism for the
entire boot sequence.
```

### Technologies

`Terraform` · `AWS EC2` · `VPC` · `Route53 Private DNS` · `IAM` · `SSM Parameter Store` · `Jenkins JCasC` · `SonarQube` · `Nexus` · `OWASP Dependency Check` · `Prometheus` · `Grafana` · `Node Exporter`

| Metric | Value |
|--------|-------|
| EC2 Instances | 10 |
| Terraform Resources | 55+ |
| Pipeline Stages | 7 |
| Deployment Time | ~15 min |
| Manual Steps | 0 |
| Secrets Hardcoded | 0 |

📖 **[Full Documentation →](2-AWS-Lift-Shift-with-CICD-Monitoring/README.md)**

---

## Phase 3 — The Mantle: Cloud-Native PaaS with Enterprise DevSecOps

> *Zero-Trust delivery. Three security gates. No server to manage. One command to production.*

**Directory:** `3-AWS-Cloud-Native-with-DevSecOps/`

<div align="center">

![Phase 3 Architecture](media/cloud-native/architecture-diagram.png)
*Full DevSecOps pipeline — Elastic Beanstalk auto-scaling across 3 AZs, managed data services in private subnets, and three independent security scanners enforcing Zero-Trust delivery*

</div>

### What Was Built

A complete PaaS deployment with Elastic Beanstalk, RDS, ElastiCache, and Amazon MQ — all provisioned by Terraform — with a 4-stage CodePipeline enforcing three independent security checks before any code reaches production.

### The Zero-Trust Pipeline

```
git push → main
     │
     ▼
SECURITY STAGE (AWS CodeBuild)
  Gate 1: TruffleHog filesystem scan
          507 chunks scanned — verified_secrets: 0 ✅
  Gate 2: tfsec ./terraform/
          IaC misconfigurations surfaced and logged ⚠️
  Gate 3: SonarCloud SAST
          24,000 lines analyzed — Quality Gate: PASS ✅
     │
     ▼
BUILD STAGE → Maven → ROOT.war → CodeArtifact (private Maven proxy)
     │
     ▼
DEPLOY STAGE → Elastic Beanstalk rolling deploy (74 seconds)
```

### Managed Services — No Servers

```
Before (Phase 2):        After (Phase 3):
5 EC2 for app stack  →   Elastic Beanstalk Auto Scaling Group
1 EC2 for MySQL      →   RDS MySQL 8.0 (managed, multi-AZ ready)
1 EC2 for Memcached  →   ElastiCache Memcached 1.6
1 EC2 for RabbitMQ   →   Amazon MQ RabbitMQ 3.13
2 EC2 for monitoring →   CloudWatch + SNS (serverless alerts)
```

### Technologies

`Terraform` · `Elastic Beanstalk` · `RDS MySQL` · `ElastiCache` · `Amazon MQ` · `AWS CodePipeline` · `AWS CodeBuild` · `AWS CodeArtifact` · `TruffleHog` · `tfsec` · `SonarCloud` · `SSM Parameter Store` · `CloudWatch` · `SNS`

| Metric | Value |
|--------|-------|
| Terraform Resources | 67 |
| Security Scanners | 3 |
| Lines Analyzed (SAST) | 24,000 |
| Deployment Time | ~12 min |
| Manual Steps | 0 |
| Hardcoded Credentials | 0 |

📖 **[Full Documentation →](3-AWS-Cloud-Native-with-DevSecOps/README.md)**

---

## Phase 4.1 — The Crust: Docker Compose Lift & Shift with Ansible

> *Same application. Fully containerized. One EC2. Zero manual SSH.*

**Directory:** `4.1-Docker-Compose-Lift-Shift-with-Ansible/`

<div align="center">

![Phase 4.1 Architecture](media/Docker-compose/The-Big-Picture-Infrastructure-App-Architecture.png)
*Terraform provisions the EC2 instance and auto-generates the Ansible inventory — Ansible installs Docker, copies the compose stack, and brings up 5 healthy containers via a single playbook run*

</div>

### What Was Built

The entire 5-tier application containerized with Docker Compose — using a two-file dev/production strategy — deployed to a single AWS EC2 instance via a fully automated Ansible playbook. Terraform auto-generates the Ansible inventory file, eliminating the last manual step.

### The Two-File Docker Strategy

```
docker-compose.yml (Development)
  └── Builds images from source code
  └── Used for local development only

docker-compose.prod.yml (Production)
  └── Pulls pre-built images from Docker Hub
  └── Zero source code on the production server
  └── Zero Maven, zero build tools on the server
  └── Ansible ships this file — nothing else
```

### Health-Aware Container Startup

```
vprodb    ── mysqladmin ping ✅ ──────────────────────────┐
vprocache ── bash TCP probe  ✅ ──────────────────────────┤
vpromq01  ── rabbitmq-diagnostics ping ✅ ────────────────┤
                                    all healthy ──► vproapp starts
                                                        └─► healthy ──► vproweb starts
```

### Engineering Challenges Solved

**Build vs. Run Trap:** Docker silently fell back to an old image with hardcoded credentials because the server had no source code to build from. Fixed with the two-file production strategy — production images are pre-built and pushed to Docker Hub; the server only pulls.

**Container Race Condition:** Tomcat crashed repeatedly before MySQL was ready. Solved with `depends_on: condition: service_healthy` across all three backing services.

**Blind Healthcheck:** Memcached reported unhealthy because the minimal Alpine image had no `nc` binary. Fixed with a pure bash TCP probe using `/dev/tcp`.

### Technologies

`Docker` · `Docker Compose` · `Ansible` · `Terraform` · `AWS EC2` · `Multi-Stage Builds` · `Docker Hub`

| Metric | Phase 2 | Phase 4.1 |
|--------|---------|-----------|
| EC2 Instances | 10 | 1 |
| Monthly Cost | ~$70 | ~$20 |
| Ansible Tasks | — | 7 |
| Manual SSH | 0 | 0 |
| Containers | 0 | 5 |

📖 **[Full Documentation →](4.1-Docker-Compose-Lift-Shift-with-Ansible/README.md)**

---

## Phase 4.2 — The Summit: ECS Fargate + GitHub Actions + Datadog

> *Serverless containers. GitOps delivery. Full-stack observability. Production-grade at every layer.*

**Directory:** `4.2-Docker-Cloud-Native-Serverless-with-Datadog/`

<div align="center">

![Phase 4.2 Architecture](media/Docker-ECS/diagram.png)
*The complete cloud-native system — GitHub Actions CI/CD with Trivy at three scan layers, ECS Fargate running 3-container tasks with Datadog sidecar, managed data services in private subnets, and Datadog collecting logs, metrics, and APM traces*

</div>

### What Was Built

The final and most complete phase — the Java application running on AWS ECS Fargate as a 3-container task (application + Datadog Agent + Firelens log router), deployed automatically by a 6-stage GitHub Actions pipeline that scans for vulnerabilities at three different layers before pushing to ECR.

### The Three Pillars

```
SECURITY              AUTOMATION            OBSERVABILITY
────────────          ──────────────        ─────────────────
Trivy FS Scan         GitHub Actions        Datadog APM
Trivy Config Scan     Docker Build          Distributed Tracing
Trivy Image Scan      ECR Push              JVM Heap + GC Metrics
CVE → GitHub GHAS     ECS Force Deploy      Logs Explorer
SARIF Reports         SSM Secrets           Infrastructure Metrics
```

### The CI/CD Pipeline — 6 Stages, 8m 45s

```
git push to main
     │
     ▼
Job 1: Get SSM Parameters  (15s)
  └── ECR registry, ECS cluster, service names — all from SSM
  └── Zero hardcoded values in the workflow file

Job 2: Trivy Code + Config Scan  (1m 11s)
  └── trivy fs . → pom.xml + Maven dependencies
  └── trivy config . → Dockerfile + Terraform
  └── SARIF uploaded → GitHub Security tab

Job 3: Docker Build  (1m 44s)
  └── Multi-stage: Maven builder → Tomcat + Datadog Java agent v1.36.0
  └── Tagged with git SHA — every build fully traceable

Job 4: Trivy Image Scan  (54s)
  └── Full image layer CVE scan
  └── SARIF uploaded → GitHub Security tab

Job 5: Push to ECR  (45s)
  └── Push git SHA tag + latest tag

Job 6: Deploy to ECS  (3m 26s)
  └── Fetch current task definition from AWS
  └── Render new task definition with updated image
  └── Deploy + wait-for-service-stability
```

### ECS Task — 3 Containers, One Unit

```
ECS Fargate Task (1024 CPU / 2048 MB)
│
├── Container 1: datadog-log-router  (64 CPU / 128 MB)  ← MUST BE FIRST
│   └── aws-for-fluent-bit:stable
│   └── Routes vproapp stdout → Datadog Logs Explorer via HTTPS
│   └── Own logs → CloudWatch (backup)
│
├── Container 2: datadog-agent  (256 CPU / 512 MB)
│   └── datadog/agent:latest
│   └── Collects CPU/Memory/Network metrics
│   └── Receives APM traces from vproapp via unix socket
│
└── Container 3: vproapp  (512 CPU / 1024 MB)  ← ESSENTIAL
    └── <ecr>/<repo>:<git-sha>
    └── Logs → awsfirelens driver
    └── APM traces → unix:///var/run/datadog/apm.socket

Shared Volume: dd-sockets
  └── Mounted in vproapp + datadog-agent at /var/run/datadog
  └── Unix socket — faster than network, no port binding needed
```

### Datadog Observability Stack

```
vproapp (Tomcat + Datadog Java Agent v1.36.0)
│
├── LOGS    → Firelens → http-intake.logs.datadoghq.com
│             Backup  → CloudWatch /ecs/vprofile-app
│
├── APM     → Datadog Agent (unix socket)
│             └── Distributed traces per HTTP request
│             └── Endpoint latency p50 / p95 / p99
│             └── Request rate and error rate
│
└── JVM     → Datadog Agent
              └── Heap / Non-Heap usage
              └── GC Old Gen / New Gen pressure
              └── Thread count + Classes loaded
```

### SSM Parameter Store — Zero Hardcoded Values

```
/strata-ops/
├── mysql-password       (SecureString) ← Terraform auto-generates
├── rabbitmq-password    (SecureString) ← Terraform auto-generates
├── datadog-api-key      (SecureString) ← Provided at terraform apply
└── pipeline/
    ├── ecr-registry     (String) ← <account>.dkr.ecr.<region>.amazonaws.com
    ├── ecr-repo         (String) ← dockertomcat_repo_staraops
    ├── ecs-cluster      (String) ← strata-tomcat-cluster
    ├── ecs-service      (String) ← eprofile-tomcat-svc
    └── ecs-task-family  (String) ← eprofile-tomcat-task
```

### Technologies

`Docker` · `AWS ECS Fargate` · `AWS ECR` · `GitHub Actions` · `Trivy` · `GitHub Advanced Security (SARIF)` · `Terraform` · `ALB` · `RDS MySQL` · `ElastiCache` · `AWS MQ` · `SSM Parameter Store` · `Datadog APM` · `Firelens (Fluent Bit)` · `CloudWatch`

| Metric | Value |
|--------|-------|
| Pipeline Duration | 8m 45s |
| Trivy Scan Layers | 3 (FS + Config + Image) |
| CVEs Detected + Reported | 310 |
| ECS Containers per Task | 3 |
| Terraform Resources | ~45 |
| Hardcoded Values in Workflow | 0 |
| Manual Steps to Deploy | 0 |

📖 **[Full Documentation →](4.2-Docker-Cloud-Native-Serverless-with-Datadog/README.md)**

---

## Evolution at a Glance

### Architecture Comparison

| Aspect | Phase 1 | Phase 2 | Phase 3 | Phase 4.1 | Phase 4.2 |
|--------|---------|---------|---------|-----------|-----------|
| **Platform** | VirtualBox | EC2 | Elastic Beanstalk | EC2 + Docker | ECS Fargate |
| **Database** | Manual MySQL | EC2 MySQL | RDS MySQL | Docker MySQL | RDS MySQL |
| **Caching** | Manual Memcached | EC2 Memcached | ElastiCache | Docker Memcached | ElastiCache |
| **Messaging** | Manual RabbitMQ | EC2 RabbitMQ | Amazon MQ | Docker RabbitMQ | Amazon MQ |
| **Deployment** | Manual SSH | Terraform | CodePipeline | Terraform + Ansible | GitHub Actions |
| **Security** | None | Basic SGs | 3-Layer Scan | Basic SGs | Trivy + GHAS |
| **Observability** | None | Prometheus + Grafana | CloudWatch | None | Datadog Full Stack |
| **Scaling** | Manual | Manual | Auto-scaling | Manual | Fargate Auto-scale |
| **Cost/month** | $0 | ~$70 | ~$170 | ~$20 | ~$178 |

### Deployment Time Evolution

```
Phase 1 Manual    60 min  ████████████████████████████████████████
Phase 1 Auto      15 min  ██████████
Phase 2           20 min  █████████████
Phase 3           12 min  ████████
Phase 4.1          8 min  █████
Phase 4.2          9 min  ██████
```

### Manual Steps Evolution

```
Phase 1 Manual    50+  ████████████████████████████████████████
Phase 1 Auto        1  █
Phase 2             0  (after terraform apply)
Phase 3             0  (after 1-time GitHub connection)
Phase 4.1           0
Phase 4.2           0
```

---

## Repository Structure

```
Strata-Ops/
│
├── 1.1-Local-Setup-Manual/                    # Phase 1a: Manual VM provisioning
├── 1.2-Local-Setup-Automated-Vagrand/         # Phase 1b: Vagrant automation
│
├── 2-AWS-Lift-Shift-with-CICD-Monitoring/     # Phase 2: AWS + Jenkins + Monitoring
│   ├── terraform/                             # 10 EC2 instances, VPC, Route53, IAM
│   ├── userdata-EC2/                          # jenkins.sh, nexus.sh, sonar.sh...
│   └── Jenkinsfile                            # 7-stage pipeline definition
│
├── 3-AWS-Cloud-Native-with-DevSecOps/         # Phase 3: PaaS + CodePipeline + Security
│   ├── terraform/                             # 67 resources
│   ├── buildspec-build.yml                    # Maven build
│   └── buildspec-sec.yml                      # TruffleHog + tfsec + SonarCloud
│
├── 4.1-Docker-Compose-Lift-Shift-with-Ansible/ # Phase 4.1: Docker + Ansible
│   ├── terraform/                             # EC2 + auto-generated inventory
│   ├── ansible/                               # Playbook + inventory.ini
│   └── docker-stack/                          # Dockerfiles + compose files
│
├── 4.2-Docker-Cloud-Native-Serverless-with-Datadog/ # Phase 4.2: ECS + GitOps
│   └── terraform/                             # ~45 AWS resources
│
├── media/                                     # Architecture diagrams + screenshots
│   ├── Lift-shift/
│   ├── cloud-native/
│   ├── Docker-compose/
│   └── Docker-ECS/
│
├── src/                                       # Java application source
├── Dockerfile-with-Datadog                    # Production build (APM enabled)
├── .github/workflows/docker-image.yml         # CI/CD Pipeline
└── pom.xml
```

---

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