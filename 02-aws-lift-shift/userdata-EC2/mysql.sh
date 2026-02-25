#!/bin/bash
set -e

echo "Installing AWS CLI and Dependencies..."
sudo dnf update -y
sudo dnf install git zip unzip curl -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
DATABASE_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" --with-decryption --query "Parameter.Value" --output text --region $REGION)

sudo dnf install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

cd /tmp/
rm -rf Strata-Ops
git clone -b main https://github.com/amramer101/Strata-Ops.git

echo "Configuring MariaDB..."
sudo mysqladmin -u root password "$DATABASE_PASS"

sudo mysql -u root -p"$DATABASE_PASS" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS';
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