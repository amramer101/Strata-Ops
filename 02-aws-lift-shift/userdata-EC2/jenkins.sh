#!/bin/bash
set -e

echo "Starting Jenkins Enterprise Provisioning..."

# 1. Update and install prerequisites including Java 21
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-21-jre wget curl unzip

# 2. Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

# 3. Disable the Initial Setup Wizard (We are using JCasC)
sudo sed -i 's/Environment="JAVA_OPTS=-Djava.awt.headless=true"/Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/g' /usr/lib/systemd/system/jenkins.service

# 4. Download Jenkins Plugin Manager CLI
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.14/jenkins-plugin-manager-2.12.14.jar

# 5. Install all required plugins
sudo java -jar jenkins-plugin-manager-2.12.14.jar \
  --war /usr/share/java/jenkins.war \
  --plugin-download-directory /var/lib/jenkins/plugins \
  --plugins configuration-as-code git github workflow-aggregator credentials plain-credentials ssh-credentials sonar slack maven-plugin email-ext timestamper ws-cleanup

# 6. Setup JCasC Directory and Download your YAML file
sudo mkdir -p /var/lib/jenkins/casc_configs

sudo curl -L "https://raw.githubusercontent.com/amramer101/Strata-Ops/main/02-aws-lift-shift/userdata-EC2/jenkins.yaml" -o /var/lib/jenkins/casc_configs/jenkins.yaml

sudo chown -R jenkins:jenkins /var/lib/jenkins/casc_configs

# 7. Inject Environment Variables (Passwords and JCasC Path)
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
cat <<EOF | sudo tee /etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs/jenkins.yaml"
Environment="ADMIN_PASSWORD=admin123"
Environment="NEXUS_PASSWORD=admin123"
Environment="SONAR_TOKEN=your_sonar_token_here"
Environment="SLACK_TOKEN=your_slack_token_here"
Environment="GITHUB_PRIVATE_KEY=your_private_key_here"
EOF

# 8. Reload and Restart Jenkins
sudo systemctl daemon-reload
sudo chown -R jenkins:jenkins /var/lib/jenkins/plugins
sudo systemctl restart jenkins
sudo systemctl enable jenkins

echo "Jenkins Provisioning Completed Successfully!"