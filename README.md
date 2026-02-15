# 🌋 Strata-Ops

## A Complete DevOps Journey Through the Layers of Cloud Infrastructure

> *From manual provisioning to cloud-native containers. One application, four evolutionary stages, infinite learning.*

<div align="center">

[![Terraform](https://img.shields.io/badge/Terraform-1.14.0-623CE4?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions)](https://github.com/features/actions)

</div>

---

## 🎯 What Is Strata-Ops?

**Strata-Ops** is a complete DevOps learning project that takes you from foundational infrastructure concepts to advanced cloud-native deployments. Like geological layers (strata), each phase builds upon the previous, adding complexity, automation, and modern practices.

### The Application

A production-grade **5-tier Java web application** with:
- **Frontend:** Nginx reverse proxy
- **Application:** Apache Tomcat
- **Database:** MySQL
- **Caching:** Memcached
- **Messaging:** RabbitMQ

**Same application. Four different deployment strategies. Complete DevOps mastery.**

---

## 🌍 The Journey: Four Layers

```
┌─────────────────────────────────────────────────────┐
│                   🌋 THE CRUST                      │
│          Docker + GitHub Actions + AWS ECS          │
│         Containerized · Cloud-Native · GitOps       │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                  🌋 THE MANTLE                      │
│       Elastic Beanstalk + RDS + ElastiCache         │
│         PaaS · Managed Services · CI/CD             │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                 🌋 THE OUTER CORE                   │
│          EC2 + Terraform + S3 + Route53             │
│          IaaS · Infrastructure as Code              │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                 🌋 THE INNER CORE                   │
│       VirtualBox + Vagrant + Manual Setup           │
│        Local VMs · Foundation · Learning            │
└─────────────────────────────────────────────────────┘
```

---

## 📚 The Four Phases

### 🔵 Phase 1: The Inner Core - Local Infrastructure

**Directory:** `01-local-setup/`

**What You Build:**
- 5 virtual machines on your laptop (VirtualBox + Vagrant)
- Manual service installation and configuration
- Complete understanding of each service's role

**Technologies:**
- VirtualBox
- Vagrant
- Shell scripting
- Manual provisioning

**What You Learn:**
- ✅ Service dependencies and initialization order
- ✅ Manual configuration and troubleshooting
- ✅ Network configuration and firewall rules
- ✅ Foundation for automation

**Deployment Time:** 45-60 minutes (manual)  
**Cost:** $0 (local only)

📖 **[Read Full Documentation →](01-local-setup/Manual-Setup/README.md)**

---

### 🟢 Phase 2: The Outer Core - AWS Lift & Shift

**Directory:** `02-aws-lift-shift/`

**What You Build:**
- Migrate local VMs to AWS EC2 instances
- Terraform-managed infrastructure (55 resources)
- Private/public subnet architecture with NAT Gateway
- Route53 DNS-based service discovery

**Technologies:**
- Terraform
- AWS (EC2, VPC, S3, Route53, IAM)
- Infrastructure as Code

**What You Learn:**
- ✅ Cloud migration strategies (rehosting)
- ✅ VPC design and network isolation
- ✅ IAM roles and security best practices
- ✅ Infrastructure as Code with Terraform

**Key Innovation:**
- **Hybrid artifact management** - Terraform manages both infrastructure AND application deployment
- **Zero hardcoded credentials** - IAM roles with temporary credentials
- **DNS abstraction** - Route53 Private Hosted Zone for service discovery

**Deployment Time:** ~10 minutes (automated)  
**Cost:** ~$70/month

📖 **[Read Full Documentation →](02-aws-lift-shift/README.md)**

---

### 🟡 Phase 3: The Mantle - Cloud-Native PaaS

**Directory:** `03-aws-cloud-native/`

**What You Build:**
- Platform as a Service with Elastic Beanstalk
- Managed databases (RDS MySQL)
- Managed caching (ElastiCache)
- Managed messaging (Amazon MQ)
- Full CI/CD pipeline (CodePipeline + CodeBuild)

**Technologies:**
- AWS Elastic Beanstalk
- AWS RDS, ElastiCache, Amazon MQ
- CodePipeline, CodeBuild
- Terraform (67 resources)

**What You Learn:**
- ✅ PaaS vs IaaS trade-offs
- ✅ Managed services benefits and costs
- ✅ CI/CD pipeline design and automation
- ✅ Zero-downtime rolling deployments
- ✅ Environment variable injection patterns

**Key Innovation:**
- **Git-based deployments** - Push to main → Auto build → Auto deploy
- **Bastion-driven DB initialization** - Automatic schema loading
- **Zero server management** - AWS handles scaling, patching, monitoring

**Deployment Time:** ~12 minutes (automated)  
**Cost:** ~$170/month

📖 **[Read Full Documentation →](03-aws-cloud-native/README.md)**

---

### 🔴 Phase 4: The Crust - Containerized Cloud-Native

**Directory:** `04-containerized-cloud/` *(Coming Soon)*

**What You Build:**
- Multi-container Docker application
- GitHub Actions CI/CD pipeline
- AWS ECS Fargate deployment
- ECR container registry
- Service mesh architecture

**Technologies:**
- Docker & Docker Compose
- GitHub Actions
- AWS ECS, ECR, Fargate
- Application Load Balancer
- CloudWatch Container Insights

**What You Learn:**
- ✅ Container orchestration with ECS
- ✅ GitOps workflows with GitHub Actions
- ✅ Microservices architecture patterns
- ✅ Container security and optimization
- ✅ Serverless containers (Fargate)

**Key Innovation:**
- **Container-first architecture** - Portable across any cloud
- **GitOps automation** - Infrastructure and application in Git
- **True cloud-agnostic** - Docker runs anywhere
- **Serverless containers** - No EC2 instances to manage

**Deployment Time:** ~8 minutes (automated)  
**Cost:** ~$120/month (estimated)

📖 **[Documentation Coming Soon]**

---

## 🚀 Quick Start Guide

### Prerequisites

```bash
# For Phase 1 (Local)
- VirtualBox 6.0+
- Vagrant 2.2+
- 8GB RAM, 20GB disk

# For Phases 2-4 (AWS)
- AWS Account
- Terraform 1.14+
- AWS CLI 2.0+
- Git

# For Phase 4 (Containers)
- Docker Desktop
- GitHub Account
```

### Choose Your Starting Point

#### 🔰 Beginner? Start with Phase 1
```bash
cd 01-local-setup/Manual-Setup
vagrant up
# Follow the manual setup guide
```

#### 💼 Have Cloud Experience? Jump to Phase 2
```bash
cd 02-aws-lift-shift/terraform
terraform init
terraform apply
```

#### 🚀 Ready for Modern DevOps? Go to Phase 3
```bash
cd 03-aws-cloud-native/terraform
terraform init
terraform apply
```

#### 🏆 Want Cutting-Edge? Phase 4 Awaits
```bash
cd 04-containerized-cloud
docker-compose up
# Deploy via GitHub Actions
```

---

## 📊 Evolution Comparison

### Architecture Comparison

| Aspect | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|--------|---------|---------|---------|---------|
| **Platform** | VirtualBox | AWS EC2 | Elastic Beanstalk | ECS Fargate |
| **Database** | Self-hosted MySQL | EC2 MySQL | RDS MySQL | RDS MySQL |
| **Caching** | Self-hosted Memcached | EC2 Memcached | ElastiCache | ElastiCache |
| **Messaging** | Self-hosted RabbitMQ | EC2 RabbitMQ | Amazon MQ | Amazon MQ |
| **Networking** | Vagrant NAT | VPC + NAT Gateway | VPC + Managed LB | VPC + ALB |
| **Deployment** | Manual SSH | Terraform | CI/CD Pipeline | GitHub Actions |
| **Scaling** | Manual | Manual ASG | Auto-scaling | Fargate auto-scale |

### Deployment Time Evolution

```
Phase 1: 45-60 minutes  (Manual commands)
Phase 2: ~10 minutes    (Terraform)
Phase 3: ~12 minutes    (Terraform + managed services)
Phase 4: ~8 minutes     (Containers + GitOps)
```

### Cost Analysis

| Phase | Monthly Cost | What You Pay For |
|-------|--------------|------------------|
| Phase 1 | **$0** | Local resources only |
| Phase 2 | **~$70** | 5x EC2 t2.micro + NAT Gateway |
| Phase 3 | **~$170** | Beanstalk + RDS + ElastiCache + MQ |
| Phase 4 | **~$120** | Fargate tasks + ALB + managed services |

**💡 Note:** Phase 3 costs more but provides fully managed infrastructure. Phase 4 optimizes by using serverless containers.

---

## 🎓 Complete Learning Path

### What You Master Through All Four Phases

#### Infrastructure & Cloud
- ✅ Manual server provisioning and configuration
- ✅ Infrastructure as Code (Terraform)
- ✅ AWS networking (VPC, subnets, routing)
- ✅ Cloud migration strategies (Lift & Shift)
- ✅ Platform as a Service (PaaS) concepts
- ✅ Container orchestration (ECS)

#### DevOps Practices
- ✅ Configuration management
- ✅ Immutable infrastructure
- ✅ CI/CD pipeline design
- ✅ GitOps workflows
- ✅ Infrastructure automation
- ✅ Deployment strategies (rolling, blue-green)

#### Security
- ✅ Network isolation and segmentation
- ✅ IAM roles and policies
- ✅ Secrets management
- ✅ Security groups and NACLs
- ✅ Container security best practices

#### Application Deployment
- ✅ Multi-tier application architecture
- ✅ Service discovery patterns
- ✅ Load balancing strategies
- ✅ Database initialization and migration
- ✅ Caching patterns
- ✅ Message queue integration

---

## 🏗️ Application Architecture

### The 5-Tier Stack (Consistent Across All Phases)

```
┌──────────────────────────────────────────┐
│         🌐 FRONTEND LAYER                │
│         Nginx Reverse Proxy              │
│         • SSL Termination                │
│         • Load Balancing                 │
│         • Static Content                 │
└────────────────┬─────────────────────────┘
                 │
┌────────────────▼─────────────────────────┐
│      ☕ APPLICATION LAYER                 │
│      Apache Tomcat 10                    │
│      • Java Web Application              │
│      • Business Logic                    │
│      • API Endpoints                     │
└──┬──────────┬──────────┬─────────────────┘
   │          │          │
   ▼          ▼          ▼
┌──────┐  ┌──────┐  ┌──────┐
│ 🗄️   │  │ 💾   │  │ 📨   │
│MySQL │  │Memcd │  │RabMQ │
│      │  │      │  │      │
│:3306 │  │11211 │  │:5672 │
└──────┘  └──────┘  └──────┘
DATABASE   CACHE     QUEUE
```

### Service Communication

```
User Request
    ↓
Nginx (Port 80/443)
    ↓
Tomcat (Port 8080)
    ↓
    ├─→ MySQL (Port 3306) ────────→ Data Storage
    ├─→ Memcached (Port 11211) ────→ Caching Layer
    └─→ RabbitMQ (Port 5672) ──────→ Async Processing
```

---

## 🔄 The Evolution Narrative

### Phase 1 → Phase 2: Local to Cloud
**Key Change:** Infrastructure location  
**Lesson:** Cloud is just someone else's computer  
**Skill:** Translating local concepts to AWS services

### Phase 2 → Phase 3: IaaS to PaaS
**Key Change:** Management responsibility  
**Lesson:** Trade cost for operational simplicity  
**Skill:** Choosing managed vs self-hosted services

### Phase 3 → Phase 4: VMs to Containers
**Key Change:** Deployment unit  
**Lesson:** Portability and consistency  
**Skill:** Container orchestration and GitOps

---

## 📁 Project Structure

```
Strata-Ops/
│
├── 01-local-setup/
│   ├── Manual-Setup/           # Phase 1: Manual provisioning
│   │   ├── Vagrantfile
│   │   └── README.md
│   └── Automated-Setup/        # Phase 1b: Automated provisioning
│       └── README.md
│
├── 02-aws-lift-shift/          # Phase 2: AWS Migration
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── vpc.tf
│   │   ├── ec2-instances.tf
│   │   ├── iam.tf
│   │   ├── route53.tf
│   │   └── s3.tf
│   ├── media/                  # Architecture diagrams
│   └── README.md
│
├── 03-aws-cloud-native/        # Phase 3: PaaS + CI/CD
│   ├── terraform/
│   │   ├── vpc.tf
│   │   ├── Data-services.tf   # RDS, ElastiCache, MQ
│   │   ├── bean-app.tf        # Elastic Beanstalk
│   │   ├── code-build.tf      # CI/CD Pipeline
│   │   └── iam-bean.tf
│   ├── src/                    # Java application source
│   ├── buildspec.yml           # CodeBuild config
│   ├── media/
│   └── README.md
│
├── 04-containerized-cloud/     # Phase 4: Containers + GitOps
│   ├── docker/
│   │   ├── Dockerfile.nginx
│   │   ├── Dockerfile.tomcat
│   │   └── docker-compose.yml
│   ├── .github/
│   │   └── workflows/
│   │       └── deploy.yml      # GitHub Actions
│   ├── terraform/
│   │   ├── ecs-cluster.tf
│   │   ├── ecs-services.tf
│   │   └── alb.tf
│   └── README.md
│
└── README.md                   # This file
```

---

## 🛠️ Technologies Used

### Infrastructure
- **Virtualization:** VirtualBox, Vagrant
- **IaC:** Terraform
- **Cloud:** AWS (EC2, VPC, S3, Route53, RDS, ElastiCache, Elastic Beanstalk, ECS, ECR, Fargate)

### CI/CD
- **Pipelines:** AWS CodePipeline, CodeBuild, GitHub Actions
- **Source Control:** Git, GitHub
- **Artifact Storage:** S3, ECR

### Application Stack
- **Frontend:** Nginx
- **Backend:** Apache Tomcat 10, Java 17
- **Database:** MySQL 8.0
- **Cache:** Memcached
- **Queue:** RabbitMQ
- **Build:** Maven

### Containers (Phase 4)
- **Runtime:** Docker
- **Orchestration:** AWS ECS
- **Registry:** AWS ECR
- **Compute:** Fargate (serverless)

---

## 💡 Pro Tips for Each Phase

### Phase 1 Tips
- 📸 **Screenshot everything** - Documentation is power
- 🔄 **Break things intentionally** - Learn by fixing
- ⏱️ **Time each service** - Understand bottlenecks
- 📝 **Document your process** - Future you will thank you

### Phase 2 Tips
- 💰 **Use `terraform plan`** - Always preview before apply
- 🔐 **Never commit credentials** - Use IAM roles
- 📊 **Enable AWS Cost Explorer** - Track spending early
- 🚨 **Set billing alerts** - Prevent surprise costs

### Phase 3 Tips
- 🔍 **Read CloudWatch logs** - Debugging managed services
- 🔄 **Test rollback procedures** - Know your escape plan
- 📈 **Monitor auto-scaling** - Understand scaling triggers
- 💾 **Schedule DB snapshots** - Backups are non-negotiable

### Phase 4 Tips
- 🐳 **Optimize Docker images** - Multi-stage builds
- 🔒 **Scan for vulnerabilities** - Use AWS ECR scanning
- 📊 **Use Container Insights** - Monitor resource usage
- 🚀 **Implement health checks** - Ensure zero-downtime deployments

---

## 🎯 Common Pitfalls and Solutions

### Cross-Phase Issues

#### Issue: "It works on my machine"
**Phases:** 1, 2  
**Solution:** Use infrastructure as code (Terraform) to ensure consistency

#### Issue: Manual deployments are error-prone
**Phases:** 1, 2  
**Solution:** Implement CI/CD pipelines (Phase 3+)

#### Issue: High operational overhead
**Phases:** 2, 3  
**Solution:** Migrate to managed services (Phase 3) or containers (Phase 4)

#### Issue: Vendor lock-in concerns
**Phases:** 2, 3  
**Solution:** Containerize application (Phase 4) for portability

---

## 📈 Metrics and KPIs

### Track Your Progress

| Metric | Phase 1 | Phase 2 | Phase 3 | Phase 4 |
|--------|---------|---------|---------|---------|
| **Deployment Time** | 60 min | 10 min | 12 min | 8 min |
| **Manual Steps** | 50+ | 5 | 1 | 0 |
| **Automation %** | 0% | 70% | 95% | 100% |
| **Mean Time to Deploy** | 1 hour | 10 min | 5 min | 3 min |
| **Rollback Time** | N/A | 15 min | 5 min | 2 min |
| **Infrastructure as Code** | No | Yes | Yes | Yes |

---

## 🏆 Certification Path

### How Strata-Ops Prepares You

#### AWS Certifications
- ✅ **AWS Certified Cloud Practitioner** - Phase 2 covers fundamentals
- ✅ **AWS Solutions Architect Associate** - Phases 2-3 cover core services
- ✅ **AWS DevOps Engineer Professional** - Phase 3-4 cover automation

#### DevOps Skills
- ✅ **Terraform Associate** - Phase 2+ extensive IaC practice
- ✅ **Docker Certified Associate** - Phase 4 containers
- ✅ **Kubernetes** - Foundation from Phase 4 ECS knowledge

---

## 🤝 Contributing

We welcome contributions! Here's how:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-improvement`)
3. **Commit** your changes (`git commit -m 'Add: amazing improvement'`)
4. **Push** to the branch (`git push origin feature/amazing-improvement`)
5. **Open** a Pull Request

### Areas for Contribution
- 📖 Documentation improvements
- 🐛 Bug fixes
- ✨ New features or phases
- 🎨 Architecture diagram enhancements
- 💡 Best practice suggestions

---

## 📚 Additional Resources

### Official Documentation
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)

### Learning Resources
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [The Twelve-Factor App](https://12factor.net/)
- [Cloud Native Computing Foundation](https://www.cncf.io/)

### Community
- [AWS re:Post](https://repost.aws/)
- [Terraform Community Forum](https://discuss.hashicorp.com/)
- [DevOps Stack Exchange](https://devops.stackexchange.com/)

---

## 🗓️ Project Roadmap

### ✅ Completed
- Phase 1: Inner Core (Manual + Automated)
- Phase 2: Outer Core (AWS Lift & Shift)
- Phase 3: The Mantle (Cloud-Native PaaS)

### 🚧 In Progress
- Phase 4: The Crust (Containerized deployment)

### 🔮 Future Enhancements
- Phase 5: Kubernetes deployment
- Multi-cloud strategies (Azure, GCP)
- GitOps with ArgoCD
- Service mesh with Istio
- Observability stack (Prometheus, Grafana)
- Cost optimization automation

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Inspiration:** Real-world DevOps challenges
- **Application:** Based on vProfile project by HKH Coder
- **Cloud Provider:** AWS for comprehensive service offerings
- **Tools:** Terraform, Docker, and the entire open-source ecosystem

---

## 📞 Support

- 📧 **Email:** [Create an issue](https://github.com/yourusername/strata-ops/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/yourusername/strata-ops/discussions)
- 📖 **Wiki:** [Project Wiki](https://github.com/yourusername/strata-ops/wiki)

---

## 🌟 Star History

If you find this project helpful, please consider giving it a ⭐ on GitHub!

---

<div align="center">

## 🌋 The Journey Through the Strata

```
From the depths of manual provisioning
Through the layers of cloud infrastructure
To the summit of cloud-native containers

Each phase builds upon the last
Each layer adds automation and power
Each step brings you closer to DevOps mastery
```

---

**Built with 🔥 for DevOps Engineers, SREs, and Cloud Architects**

**Made with geological precision by DevOps enthusiasts**

---

### Quick Navigation

[Phase 1: Inner Core](01-local-setup/Manual-Setup/README.md) | 
[Phase 2: Outer Core](02-aws-lift-shift/README.md) | 
[Phase 3: The Mantle](03-aws-cloud-native/README.md) | 
[Phase 4: The Crust](#) (Coming Soon)

---

*Last Updated: February 2026*

</div>