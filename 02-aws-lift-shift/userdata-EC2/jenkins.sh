#!/bin/bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

# 3. Disable the Initial Setup Wizard (We are using JCasC)
sudo sed -i 's/Environment="JAVA_OPTS=-Djava.awt.headless=true"/Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/g' /usr/lib/systemd/system/jenkins.service

# 4. Download Jenkins Plugin Manager CLI
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.14/jenkins-plugin-manager-2.12.14.jar

# 5. Install all required plugins
sudo java -jar jenkins-plugin-manager-2.12.14.jar \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory /var/lib/jenkins/plugins \
  --plugins configuration-as-code git github workflow-aggregator credentials plain-credentials ssh-credentials sonar slack maven-plugin email-ext timestamper ws-cleanup job-dsl nexus-artifact-uploader ssh-agent

# 6. Setup JCasC Directory and Download your YAML file
sudo mkdir -p /var/lib/jenkins/casc_configs
sudo curl -L "https://raw.githubusercontent.com/amramer101/Strata-Ops/main/02-aws-lift-shift/userdata-EC2/jenkins.yaml" -o /var/lib/jenkins/casc_configs/jenkins.yaml
sudo chown -R jenkins:jenkins /var/lib/jenkins/casc_configs


# ==============================================================================
# 7. FETCHING SECRETS FROM AWS SSM
# ==============================================================================
REGION="eu-central-1"

wait_for_ssm_param() {
  PARAM_NAME=$1
  echo "Waiting for $PARAM_NAME to be populated by its server..."
  while true; do
    VAL=$(aws ssm get-parameter --name "$PARAM_NAME" --with-decryption --query "Parameter.Value" --output text --region $REGION 2>/dev/null)
    if [[ "$VAL" != "pending" && -n "$VAL" ]]; then
      echo "$VAL"
      break
    fi
    sleep 10
  done
}

echo "Fetching parameters from AWS SSM..."

JENKINS_PASS=$(aws ssm get-parameter --name "/strata-ops/jenkins-admin-password" --with-decryption --query "Parameter.Value" --output text --region $REGION)
GITHUB_KEY=$(aws ssm get-parameter --name "/strata-ops/github-private-key" --with-decryption --query "Parameter.Value" --output text --region $REGION)
SLACK_TOK=$(aws ssm get-parameter --name "/strata-ops/slack-token" --with-decryption --query "Parameter.Value" --output text --region $REGION)
TOMCAT_SSH_KEY=$(aws ssm get-parameter --name "/strata-ops/tomcat-ssh-key" --with-decryption --query "Parameter.Value" --output text --region $REGION)

NEXUS_PASS=$(wait_for_ssm_param "/strata-ops/nexus-password")
SONAR_TOK=$(wait_for_ssm_param "/strata-ops/sonar-token")

# ==============================================================================
# 8. INJECT ENVIRONMENT VARIABLES SECURELY
# ==============================================================================
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
cat <<EOF | sudo tee /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs/jenkins.yaml"
Environment="ADMIN_PASSWORD=${JENKINS_PASS}"
Environment="NEXUS_PASSWORD=${NEXUS_PASS}"
Environment="GITHUB_PRIVATE_KEY=${GITHUB_KEY}"
Environment="TOMCAT_SSH_KEY=${TOMCAT_SSH_KEY}"
Environment="SLACK_TOKEN=${SLACK_TOK}"
EOF

# 9. Reload and Restart Jenkins
sudo systemctl daemon-reload
sudo chown -R jenkins:jenkins /var/lib/jenkins/plugins
sudo systemctl restart jenkins
sudo systemctl enable jenkins

echo "Jenkins Provisioning Completed Successfully with Secure SSM Injection!"