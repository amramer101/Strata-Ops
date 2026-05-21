
Claude finished the response
Cache_Verification.png
Connectivity.png
DB_Verification.png
MQ_Verification.png
Pipeline.png
Resources.png
Secrets.png
amramer101/Strata-Ops
main

GITHUB

amramer101/Strata-Ops
main

GITHUB

amramer101/Strata-Ops
main

GITHUB

عاوز اعمل ريدمي للمشورع دا و يبكون كويس و مش كبير و مفهوش اي ايموجيز لاني هعرضه علي azure migration manager الفكره انا الفمروض عامل ميجريشن منaws g azure اعمل جدول انا نقلت يا لاي و دي المشاكل الي واجعتني و انا حلتها ازاي   
Challenges & Solutions (قائمة التوثيق)
1. The .local Domain Conflict (mDNS)

The Problem: عند محاولة عمل ping للدومين backend.eprofile.az (أو أي دومين ينتهي بـ .local سابقاً)، كان النظام يرفض الترجمة ويعطي Temporary failure in name resolution لأن نظام Ubuntu (عن طريق systemd-resolved) كان يعتبر هذا النطاق خاصاً بالـ Multicast DNS للبحث عن أجهزة محلية.
The Solution: تم تعطيل الـ MulticastDNS في إعدادات النظام (/etc/systemd/resolved.conf) لضمان أن النظام يوجه استعلامات الـ DNS مباشرة إلى الـ Azure Private DNS Resolver.
Race Condition during Provisioning

The Problem: التيرافورم يقوم بإنشاء السيرفرات بالتوازي، مما أدى إلى قيام الـ App VM (التوم كات) قبل اكتمال تسطيب قاعدة البيانات (MariaDB) على الـ Backend VM بالكامل، فكان التطبيق يفشل في الاتصال (Communications link failure).
The Solution: تم تطبيق Wait-for-it Pattern باستخدام حلقة انتظار (while ! nc -zv ...) داخل سكربت الـ userdata الخاص بـ App VM للتأكد من أن بورت الداتابيز 3306 مفتوح وجاهز للاستقبال قبل محاولة تشغيل التوم كات.
Environment Variables Injection in Systemd

The Problem: المتغيرات التي تم تصديرها في setenv.sh (مثل RDS_HOSTNAME) لم تكن تُقرأ بواسطة التطبيق عند تشغيل التوم كات كـ Systemd Service.
The Solution: تم تحويل تمرير المتغيرات إلى Java System Properties باستخدام متغير CATALINA_OPTS داخل ملف setenv.sh (مثل: -DRDS_HOSTNAME=...) لضمان أن الـ Spring Framework يقرأ هذه الإعدادات بوضوح أثناء الـ Runtime.
GitHub Actions Connectivity (Private Network)

The Problem: الـ GitHub Runners (سيرفرات سحابية عامة) لم تكن قادرة على الوصول إلى الـ App VM الموجودة داخل شبكة أزور الخاصة (Private Subnet).
The Solution: تم استخدام الـ nginx-vm (الموجود في Public Subnet) كـ Bastion Host / Proxy في خطوات الـ SCP والـ SSH داخل الـ Pipeline، مما مكن الـ Runners من "القفز" عبر الـ Nginx للوصول للسيرفر الداخلي.
Secure Credentials Management

The Problem: كان من الضروري تجنب وضع الباسوردات والمفاتيح الحساسة في ملفات الكود أو GitHub Secrets بشكل دائم.
The Solution: تم دمج Azure Key Vault مع Terraform لإنشاء الـ Secrets أوتوماتيكياً، واستخدام الـ Managed Identity داخل السيرفرات لسحب هذه الـ Secrets أوتوماتيكياً أثناء الـ Provisioning، بالإضافة إلى سحبها بواسطة الـ Pipeline وقت الـ Deployment. اكتبها طبعا بالانجليزيز بشكل منظم كانه ريدي مي قوي و اه دا رقم 7 للشمرع انا عملت ميريشن لرقم 2 منه انا عاوز ريديمي بالانجليزي منظم لرمحلة الازور يبين مهراتي و ادق تافصيلها في ازور , و في الاخر كده عاوز احط الصور دي بشرح و عنوان ليها مناسب بالتريبت بتاعهم الص هما في Strata-Ops/media /Azure/ amramer101 amramer101 add media files to for azure 40d5718 · 1 minute ago Name Last commit message Last commit date .. Cache_Verification.png add media files to for azure 1 minute ago Connectivity.png add media files to for azure 1 minute ago DB_Verification.png add media files to for azure 1 minute ago MQ_Verification.png add media files to for azure 1 minute ago Pipeline.png add media files to for azure 1 minute ago Resources.png add media files to for azure 1 minute ago Secrets.png add media files to for azure 1 minute ago
Show more
9:02 PM

Check frontend design skill
Check frontend design skill
Now let me create the README as a markdown file:


Created a file, read a file
Created a file, read a file
Here's your README. A few notes on what I focused on:

Structure decisions:

The AWS → Azure mapping table is the centerpiece — it gives a migration manager an immediate side-by-side comparison without reading prose
Challenges are written as proper engineering documentation with the exact technical root cause, not just "it didn't work"
The secrets section has a dedicated table listing all 8 Key Vault secrets by name and purpose, which demonstrates depth of Azure Key Vault understanding
Image section follows the order: infra → secrets → pipeline → app verification → data layer verification
Image paths — I used media/Azure/ to match the folder structure you showed (Strata-Ops/media/Azure/). Make sure the README sits at the repo root (or adjust paths accordingly if it goes inside 7-Azure-Lift-Shift-with-CICD-Migration/).

One thing to double-check: the Connectivity.png image shows the login page, which I labeled as "Application Login Page / end-to-end connectivity confirmation." If you'd prefer a different description for that screenshot, just let me know.


Readme
Document · MD 

Want to be notified when Claude responds?




Claude is AI and can make mistakes. Please double-check responses.
Readme · MD
# Phase 7 — Azure Lift & Shift with CI/CD Migration
 
## Overview
 
Phase 7 is a cloud-to-cloud migration of the eProfile application from AWS (Phase 2) to Microsoft Azure. The goal was to replicate the same 3-tier production architecture — Nginx reverse proxy, Tomcat application server, and a backend VM running MariaDB, Memcached, and RabbitMQ — while adopting native Azure services for networking, secrets management, and CI/CD delivery.
 
The infrastructure is fully provisioned by Terraform, all sensitive credentials are managed through Azure Key Vault with Managed Identity authentication, and deployments are automated end-to-end via GitHub Actions.
 
---
 
## Architecture
 
```
Internet
    |
  nginx-vm  (Public Subnet — nginx-subnet-public 10.0.0.0/24)
    |   [Nginx reverse proxy + Bastion Host]
    |
  app-vm    (Private Subnet — application-subnet-private 10.0.1.0/24)
    |   [Tomcat 10 + Java 21]
    |
  backend-vm (Private Subnet — backend-subnet-private 10.0.2.0/24)
        [MariaDB 3306 | Memcached 11211 | RabbitMQ 5672]
```
 
Private VMs use a NAT Gateway for outbound internet access. Internal service discovery is handled by an Azure Private DNS Zone (`eprofile.az`) with auto-registered A records for each VM.
 
---
 
## AWS to Azure Service Mapping
 
| Layer | AWS (Phase 2) | Azure (Phase 7) | Notes |
|---|---|---|---|
| Compute | EC2 (Ubuntu 22.04) | Azure Linux VMs (Ubuntu 22.04) | Same OS, same userdata pattern |
| Networking | VPC + Subnets + IGW | VNet + Subnets + NAT Gateway | NAT Gateway replaces per-VM public IPs for private subnets |
| Security Groups | AWS Security Groups (per instance) | NSGs + Application Security Groups | ASGs allow source-based rules without hardcoding IPs |
| DNS (Internal) | Route53 Private Hosted Zone (`eprofile.in`) | Azure Private DNS Zone (`eprofile.az`) | Same A record pattern; auto-registration enabled |
| Secrets Management | AWS SSM Parameter Store | Azure Key Vault | Managed Identity replaces IAM Instance Profiles |
| Identity | IAM Roles + Instance Profiles | System-Assigned Managed Identity | Zero long-lived credentials on VMs |
| State Backend | S3 | Azure Blob Storage (azurerm backend) | `terraform-rg` / `terraformstateeprofile` |
| CI/CD | Jenkins (self-hosted EC2) | GitHub Actions | Pipeline defined in `.github/workflows/7-Azure-CICD-Migration.yml` |
| Secret injection (pipeline) | SSM `get-parameter` in Jenkinsfile | Azure Key Vault action (`get-keyvault-secrets`) | Secrets fetched at runtime per job |
| Deployment target | Direct SSH from Jenkins EC2 | SCP + SSH via Nginx Bastion proxy | GitHub runners are public; private VM requires a proxy hop |
 
---
 
## Infrastructure Components
 
**Terraform modules provisioned:**
 
- VNet (`10.0.0.0/16`) with 3 subnets across public/private tiers
- 3 Linux VMs: `nginx-vm`, `app-vm` (with Managed Identity), `backend-vm` (with Managed Identity)
- NAT Gateway with static public IP, associated to both private subnets
- Azure Private DNS Zone (`eprofile.az`) with A records for `app` and `backend`
- Azure Key Vault (`eprofile-kv-weurope-01`) with 8 secrets auto-generated at apply time
- Network Security Groups using Application Security Groups as traffic sources (no hardcoded IPs)
- Key Vault Access Policies granting `Get`/`List` to both private VMs via Managed Identity
**Secrets stored in Key Vault (all generated by Terraform):**
 
| Secret Name | Purpose |
|---|---|
| `mysql-username` | MariaDB admin username |
| `mysql-password` | MariaDB admin password (random, 8 chars) |
| `rabbitmq-username` | RabbitMQ admin username |
| `rabbitmq-password` | RabbitMQ admin password (random, 16 chars) |
| `tomcat-private-ip` | Private IP of app-vm (for CI/CD pipeline) |
| `nginx-public-ip` | Public IP of nginx-vm (bastion for CI/CD pipeline) |
| `vm-username` | SSH username for both VMs |
| `vm-ssh-key` | SSH private key (for GitHub Actions deployment) |
 
---
 
## CI/CD Pipeline
 
The GitHub Actions pipeline (`7-Azure-CICD-Migration.yml`) runs on every push to `main` and consists of three sequential jobs:
 
```
TruffleHog & Checkov Scans  (26s)
        |
    Maven Build              (39s)
        |
    Deploy WAR to Azure VM   (1m 14s)
 
Total: 1m 21s
```
 
**Job 1 — Security Scans:**
- TruffleHog scans the full commit history for verified leaked secrets
- Checkov performs IaC security scanning on all Terraform files (`soft_fail: false` — pipeline aborts on HIGH findings)
**Job 2 — Build:**
- Builds the Java WAR artifact using Maven on JDK 21
- Uploads the artifact for the deployment job
**Job 3 — Deploy:**
- Authenticates to Azure using a Service Principal (`AZURE_CREDENTIALS` secret)
- Fetches `tomcat-private-ip`, `nginx-public-ip`, `vm-username`, and `vm-ssh-key` from Key Vault at runtime
- SCPs the WAR file to the private `app-vm` using `nginx-vm` as an SSH proxy
- SSHs into `app-vm` (again via nginx proxy), stops Tomcat, replaces the WAR, restarts Tomcat
---
 
## Challenges and Solutions
 
### 1. The `.az` Domain and mDNS Conflict
 
**Problem:** When VMs attempted to resolve `backend.eprofile.az` using `ping` or `dig`, Ubuntu's `systemd-resolved` was intercepting `.local`-adjacent suffixes and routing them to Multicast DNS instead of forwarding the query to the Azure Private DNS Resolver. This resulted in `Temporary failure in name resolution` even though the DNS zone and A records were correctly configured in Azure.
 
**Solution:** `MulticastDNS` was explicitly disabled in `/etc/systemd/resolved.conf` on affected VMs. This forced all DNS queries — including for `.az` domains — to be forwarded directly to Azure's internal resolver (`168.63.129.16`), which correctly handled the Private DNS Zone lookup.
 
---
 
### 2. Race Condition During Provisioning
 
**Problem:** Terraform provisions VMs in parallel by default. The `app-vm` (Tomcat) userdata script would execute and attempt to connect to MariaDB before the `backend-vm` had finished installing and configuring the database. This caused Tomcat to fail at startup with `Communications link failure`.
 
**Solution:** A wait loop was added to the `app-vm` userdata script using `netcat`:
 
```bash
while ! nc -zv backend.eprofile.az 3306; do
  echo "Database is not up yet. Sleeping for 10 seconds..."
  sleep 10
done
```
 
Tomcat environment variables are only written and the service only started after the database port becomes reachable. A `depends_on` block in Terraform also ensures `app-vm` is created after `backend-vm`, giving the backend VM a head start.
 
---
 
### 3. Environment Variables Not Propagating to the Application
 
**Problem:** Credentials fetched from Key Vault were exported as environment variables inside `setenv.sh`. When Tomcat ran as a `systemd` service under the `tomcat` user, these exported variables were not inherited by the JVM process. The Spring application was reading null values for `RDS_HOSTNAME`, `RDS_PASSWORD`, and similar properties.
 
**Solution:** Variables were converted to Java System Properties by passing them through `CATALINA_OPTS` inside `setenv.sh`:
 
```bash
export CATALINA_OPTS="-DRDS_HOSTNAME=backend.eprofile.az -DRDS_PORT=3306 \
  -DRDS_USERNAME=$DB_USER -DRDS_PASSWORD=$DB_PASS \
  -DRABBITMQ_HOSTNAME=backend.eprofile.az ..."
```
 
Spring's `application.properties` references these as `${RDS_HOSTNAME}`, which correctly resolves System Properties set via `-D` flags regardless of how the process is started.
 
---
 
### 4. GitHub Actions Cannot Reach Private VM
 
**Problem:** GitHub-hosted runners are public cloud machines with no network path into the Azure Private Subnet where `app-vm` resides. Direct SCP and SSH to the private IP returned connection timeouts.
 
**Solution:** The `nginx-vm` (which sits in the public subnet and has a static public IP) was used as an SSH ProxyJump host in both the SCP and SSH pipeline steps:
 
```yaml
proxy_host: ${{ steps.kv.outputs.nginx-public-ip }}
proxy_username: ${{ steps.kv.outputs.vm-username }}
proxy_key: ${{ steps.kv.outputs.vm-ssh-key }}
host: ${{ steps.kv.outputs.tomcat-private-ip }}
```
 
The runner connects to Nginx on the public IP, which then tunnels the connection to the private `app-vm`. No VPN or additional Azure resources were required.
 
---
 
### 5. Zero-Credential Secret Management Across VMs and Pipeline
 
**Problem:** Credentials needed to be available in three different contexts: VM provisioning scripts, the running application (Tomcat), and the GitHub Actions deployment pipeline — without storing any secrets in code, Terraform state (in plaintext), or as permanent GitHub Secrets.
 
**Solution:** A three-layer approach was applied:
 
- **Terraform** generates all passwords using `random_password` and writes them directly to Azure Key Vault at `terraform apply` time. They never appear in userdata scripts or variable files.
- **VMs** authenticate to Key Vault using System-Assigned Managed Identity (no stored credentials on disk). Userdata scripts use the IMDS endpoint to fetch a short-lived bearer token, then call the Key Vault REST API to retrieve secrets.
- **GitHub Actions pipeline** authenticates to Azure using a Service Principal stored as a single `AZURE_CREDENTIALS` GitHub secret, then uses the official `azure/get-keyvault-secrets` action to pull only the specific secrets needed for that deployment job.
---
 
## Verification Screenshots
 
### Azure Resources
 
All 20 infrastructure resources provisioned by Terraform inside `eprofile-resource-group`, including VMs, NICs, NSGs, ASGs, Key Vault, NAT Gateway, Private DNS Zone, and public IPs.
 
![Azure Resource Group](media/Azure/Resources.png)
 
---
 
### Azure Key Vault Secrets
 
Eight secrets auto-generated and stored in `eprofile-kv-weurope-01` during `terraform apply`. All secrets have `Enabled` status with no manual intervention.
 
![Key Vault Secrets](media/Azure/Secrets.png)
 
---
 
### GitHub Actions Pipeline
 
Successful pipeline run of `7-Azure-CICD-Migration.yml` — all three jobs passed (TruffleHog & Checkov, Maven Build, Deploy WAR to Azure App VM) in 1 minute 21 seconds.
 
![CI/CD Pipeline](media/Azure/Pipeline.png)
 
---
 
### Application Login Page
 
The eProfile application served over HTTP via Nginx reverse proxy on the public IP, confirming end-to-end connectivity through the Nginx → Tomcat → Backend chain.
 
![Application Login](media/Azure/Connectivity.png)
 
---
 
### Database Verification — First Request
 
On the first user data request, the application fetches from MariaDB and writes the result to Memcached. The banner confirms the data source is the database.
 
![DB Verification](media/Azure/DB_Verification.png)
 
---
 
### Cache Verification — Subsequent Request
 
On subsequent requests for the same user, the application reads from Memcached rather than the database, confirming the cache layer is functional.
 
![Cache Verification](media/Azure/Cache_Verification.png)
 
---
 
### RabbitMQ Verification
 
Hitting the `/user/rabbit` endpoint confirms RabbitMQ is running and functional — 6 connections established, 2 channels, 5 exchanges, and 5 queues created.
 
![RabbitMQ Verification](media/Azure/MQ_Verification.png)
 






