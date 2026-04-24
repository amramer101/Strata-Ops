# ⎈ Phase 5.2 — Application Packaging & Templating with Helm

> *Same cluster. Same app. Zero hardcoding — packaging everything into a reusable, parameterized Helm chart.*

<div align="center">

[![Helm](https://img.shields.io/badge/Helm-v3.11-0F1689?style=for-the-badge&logo=helm)](https://helm.sh/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-Configuration-EE0000?style=for-the-badge&logo=ansible)](https://www.ansible.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Minikube-326CE5?style=for-the-badge&logo=kubernetes)](https://kubernetes.io/)
[![AWS EC2](https://img.shields.io/badge/AWS-EC2_+_EBS-FF9900?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/ec2/)

</div>

---

## 🎯 What Changed from Phase 5.1

Phase 5.1 ran the same 5-tier Java application on self-managed Kubernetes — but every manifest was hardcoded. Service names, image tags, passwords, replica counts — all scattered across a dozen static YAML files.

Phase 5.2 solves that with **Helm**: the entire application is packaged into a single chart (`eprofile-chart`), with all configuration centralized in one `values.yaml`. One file to change. One command to deploy.

```
Phase 5.1 → kubectl apply -f kubernetes/         (12 static YAML files, hardcoded values)
Phase 5.2 → helm upgrade --install eprofile-chart (1 chart, 1 values.yaml, full templating)
```

---

## 🏗️ What Was Built

The same infrastructure stack from 5.1 — Terraform provisions the EC2 + EBS, Ansible configures the cluster — with one key addition: **Helm** replaces raw `kubectl apply` for all workload deployments.

### The Four Pillars

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  ⚙️  PROVISION   │   │  🔧 CONFIGURE   │   │  📦 PACKAGE     │   │  ☸️  ORCHESTRATE  │
│                 │   │                 │   │                 │   │                 │
│  Terraform      │   │  Ansible        │   │  Helm v3        │   │  Minikube       │
│  EC2 t3.medium  │   │  Docker         │   │  eprofile-chart │   │  5 Workloads    │
│  EBS 2GiB       │   │  Minikube       │   │  values.yaml    │   │  Ingress NGINX  │
│  VPC + SG       │   │  Helm Install   │   │  Go Templates   │   │  PV/PVC → EBS   │
│  S3 State       │   │  helm upgrade   │   │  b64enc Secrets │   │  Systemd Svc    │
└─────────────────┘   └─────────────────┘   └─────────────────┘   └─────────────────┘
```

---

## 📦 Helm Chart Structure

```
eprofile-chart/
├── Chart.yaml              # Chart metadata — name, version, appVersion
├── values.yaml             # Single source of truth for all config
├── .helmignore             # Files excluded from chart packaging
└── templates/
    ├── db-pv.yaml          # PersistentVolume → hostPath: /mnt/vprofile-db
    ├── db-pvc.yaml         # PersistentVolumeClaim — storage size from values
    ├── db-secrets.yaml     # MySQL credentials — b64enc applied by Helm
    ├── db-statefulset.yaml # MySQL StatefulSet — image, tag, resources
    ├── db-service.yaml     # vprodb-service :3306
    ├── rabbitmq-secrets.yaml   # RMQ credentials — b64enc from values
    ├── rabbitmq-deployment.yaml
    ├── rabbitmq-service.yaml   # vprormq-service :5672
    ├── memcached-deployment.yaml
    ├── memcached-service.yaml  # vprocache-service :11211
    ├── tomcat-deployment.yaml  # vproapp + initContainers
    ├── tomcat-service.yaml     # app-tomcat-service :8080
    └── ingress.yaml            # vprofile.local.com → app-tomcat-service
```

---

## ⚡ The Core Upgrade — Templating with `values.yaml`

### Before (Phase 5.1 — Hardcoded)
```yaml
# db-statefulset.yaml — static, no reuse
image: amrmamer/vprofiledb
tag: latest
storage: 2Gi
serviceName: vprodb-service
```

### After (Phase 5.2 — Templated)
```yaml
# templates/db-statefulset.yaml
image: {{ .Values.db.image }}:{{ .Values.db.tag }}
serviceName: {{ .Values.db.serviceName }}
storage: {{ .Values.db.storage }}
```

```yaml
# values.yaml — one file controls everything
db:
  image: "amrmamer/vprofiledb"
  tag: "latest"
  storage: "2Gi"
  serviceName: "vprodb-service"
  rootPassword: "vprodbpass"
  username: "vprodb"
  password: "vprodbpass"

app:
  image: "amrmamer/vprofileapp"
  tag: "latest"
  replicaCount: 1
  serviceName: "app-tomcat-service"

rmq:
  image: "rabbitmq"
  tag: "3-management"
  replicaCount: 1
  username: "guest"
  password: "guest"
  serviceName: "vprormq-service"

memcached:
  image: "memcached"
  tag: "latest"
  replicaCount: 1
  serviceName: "vprocache-service"
```

---

## 🔐 Secrets — Helm Handles the Encoding

Phase 5.1 required manually running `echo -n "pass" | base64` for every secret and pasting the output into YAML.

Phase 5.2 uses Helm's built-in `b64enc` filter — secrets are stored as plain text in `values.yaml` and encoded at render time:

```yaml
# templates/db-secrets.yaml
data:
  root-password: {{ .Values.db.rootPassword | b64enc | quote }}
  username:      {{ .Values.db.username     | b64enc | quote }}
  password:      {{ .Values.db.password     | b64enc | quote }}
```

No manual base64. No encoding errors. No `\n` corruption (the bug that broke MySQL auth in 5.1).

---

## 🔧 Ansible — Helm Added to the Pipeline

The Ansible playbook gains two tasks over Phase 5.1:

```yaml
# Install Helm
- name: Install helm if not exists
  unarchive:
    src: https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz
    dest: /usr/local/bin
    extra_opts: "--strip-components=1"
    remote_src: true
  args:
    creates: /usr/local/bin/helm   # idempotent — skips if already installed

# Deploy with Helm instead of kubectl apply
- name: Apply Kubernetes Manifests with Helm
  become: false
  shell: |
    helm upgrade --install eprofile-chart /home/{{ ansible_user }}/kubernetes/ --namespace default
```

`helm upgrade --install` is idempotent by design — it installs on first run and upgrades on every subsequent run. No more ordering issues between `kubectl apply` calls.

---

## 🚀 Deployment — Same Flow, One Extra Tool

### Prerequisites
```bash
terraform >= 1.9
ansible   >= 2.15
aws-cli   >= 2.0
# Helm is installed automatically by the Ansible playbook
```

### Step 1 — Generate SSH Key
```bash
cd terraform
ssh-keygen -t rsa -b 4096 -f k8s-key -N ""
```

### Step 2 — Provision Infrastructure
```bash
terraform init
terraform apply --auto-approve
# inventory.ini auto-generated with the new EC2 IP
```

### Step 3 — Configure, Install Helm & Deploy
```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
# Installs Docker, Minikube, Helm → deploys eprofile-chart in one shot
```

### Step 4 — Access the Application
```bash
http://<ec2-public-ip>
# Credentials: admin_vp / admin_vp
```

### Upgrade in One Line
```bash
# Change any value in values.yaml, then:
helm upgrade eprofile-chart ./eprofile-chart/
```

---

## 📊 Phase 5.1 vs 5.2 — Side by Side

| Aspect | Phase 5.1 | Phase 5.2 |
|--------|-----------|-----------|
| Deployment tool | `kubectl apply -f` | `helm upgrade --install` |
| Configuration | Hardcoded in 12 YAML files | Centralized in `values.yaml` |
| Secrets encoding | Manual `echo -n \| base64` | Helm `b64enc` filter |
| Upgrading the app | Edit multiple files | Edit one value, re-run Helm |
| Idempotency | Per-resource via kubectl | Native via Helm release tracking |
| Packaging | Raw manifests directory | Versioned, distributable chart |
| Service name changes | Find & replace across 5 files | Change one line in `values.yaml` |

---

## 🗂️ Project Structure

```
5.2-Application-Packaging-and-Templating-with-Helm/
│
├── terraform/              # Same as 5.1 — EC2, EBS, VPC, SG, S3 state
│
├── ansible/
│   ├── playbook.yml        # 5.1 playbook + Helm install + helm upgrade
│   └── inventory.ini       # Auto-generated by Terraform
│
└── eprofile-chart/         # ← The Helm chart (replaces kubernetes/ dir)
    ├── Chart.yaml
    ├── values.yaml
    ├── .helmignore
    └── templates/          # 13 templated manifests
```

---

## 💰 Cost

| Resource | Monthly |
|----------|---------|
| EC2 t3.medium | ~$30 |
| EBS 2GiB gp2 | ~$0.20 |
| Public IP | ~$3.60 |
| S3 state | ~$0.01 |
| **Total** | **~$34/month** |

> 💡 `terraform destroy` tears everything down in under 2 minutes. Full rebuild with Helm deploy in ~8 minutes from zero.

---

## ⬅️ Journey

[← Phase 5.1: Self-Managed Kubernetes on EC2](../5.1-Self-Managed-Kubernetes-on-EC2/README.md) | [→ Phase 6: EKS (Coming Soon)](../6-EKS/README.md) | [↑ Main README](../README.md)

---

<div align="center">

*Phase 5.2 — Application Packaging & Templating with Helm*

**Provisioned · Configured · Packaged · Deployed**

*by [Amr Medhat Amer](https://github.com/amramer101) — Cloud DevSecOps*

</div>