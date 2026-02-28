#!/bin/bash
set -e

echo "Starting MySQL Provisioning on Ubuntu 22.04..."

apt update -y
apt install -y mariadb-server git curl awscli

systemctl start mariadb
systemctl enable mariadb

# Fetch password from SSM
REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
DATABASE_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" \
  --with-decryption --query "Parameter.Value" --output text --region $REGION)

echo "Configuring MariaDB..."
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS accounts;"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY '$DATABASE_PASS';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY '$DATABASE_PASS';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

echo "Restoring Database Dump..."
cd /tmp
git clone -b main https://github.com/amramer101/Strata-Ops.git
sudo mysql -u root accounts < /tmp/Strata-Ops/src/main/resources/db_backup.sql

echo "Verifying..."
sudo mysql -u root accounts -e "SHOW TABLES;"

echo "MySQL Provisioning Completed Successfully!"