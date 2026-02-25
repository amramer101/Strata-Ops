#!/bin/bash
set -e

echo "Starting Tomcat 10 Provisioning..."

sudo apt update
sudo apt upgrade -y

sudo apt install openjdk-17-jdk awscli -y
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y

REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
DB_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" --with-decryption --query "Parameter.Value" --output text --region $REGION)

echo "Injecting Environment Variables for Stage 2..."
sudo mkdir -p /usr/share/tomcat10/bin

cat <<EOF | sudo tee /usr/share/tomcat10/bin/setenv.sh
export RDS_HOSTNAME=db01.eprofile.in
export RDS_PORT=3306
export RDS_DB_NAME=accounts
export RDS_USERNAME=admin
export RDS_PASSWORD=${DB_PASS}
export RABBITMQ_HOSTNAME=rmq01.eprofile.in
export MEMCACHED_HOSTNAME=mc01.eprofile.in
EOF

sudo chmod +x /usr/share/tomcat10/bin/setenv.sh
sudo chown tomcat:tomcat /usr/share/tomcat10/bin/setenv.sh

sudo systemctl daemon-reload
sudo systemctl enable tomcat10
sudo systemctl restart tomcat10

echo "Tomcat Provisioning Completed! Server is ready to receive WAR from Jenkins."