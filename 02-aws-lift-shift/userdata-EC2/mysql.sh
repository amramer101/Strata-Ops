#!/bin/bash
set -e

echo "Installing Dependencies..."
sudo yum update -y
sudo yum install -y git curl unzip

# AWS CLI already pre-installed on Amazon Linux 2
aws --version

REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
DATABASE_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" \
  --with-decryption --query "Parameter.Value" --output text --region $REGION)

echo "Installing MariaDB..."
sudo yum install -y mariadb mariadb-server

sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "Cloning repo for DB dump..."
cd /tmp/
rm -rf Strata-Ops
git clone -b main https://github.com/amramer101/Strata-Ops.git

echo "Configuring MariaDB..."
sudo mysqladmin -u root password "$DATABASE_PASS"

sudo mysql -u root -p"$DATABASE_PASS" <<EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
CREATE DATABASE IF NOT EXISTS accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY '$DATABASE_PASS';
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY '$DATABASE_PASS';
FLUSH PRIVILEGES;
EOF

echo "Restoring Database Dump..."
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/Strata-Ops/src/main/resources/db_backup.sql

echo "MySQL Provisioning Completed Successfully!"