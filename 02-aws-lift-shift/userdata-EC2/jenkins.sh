#!/bin/bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y


sudo mkdir -p /var/lib/jenkins/casc_configs

sudo curl -L "https://raw.githubusercontent.com/amramer101/Strata-Ops/main/02-aws-lift-shift/userdata-EC2/jenkins.yaml" -o /var/lib/jenkins/casc_configs/jenkins.yaml

sudo chown -R jenkins:jenkins /var/lib/jenkins/casc_configs

echo 'CASC_JENKINS_CONFIG="/var/lib/jenkins/casc_configs/jenkins.yaml"' | sudo tee -a /etc/default/jenkins
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
echo -e "[Service]\nEnvironment=\"CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs/jenkins.yaml\"" | sudo tee /etc/systemd/system/jenkins.service.d/override.conf

sudo systemctl daemon-reload
sudo systemctl restart jenkins