#!/bin/bash
set -e

echo "Starting MySQL Provisioning on Ubuntu 22.04..."

# Wait for network/NAT Gateway to be ready
echo "Waiting for network connectivity..."
until curl -s --max-time 5 http://archive.ubuntu.com > /dev/null 2>&1; do
  echo "Network not ready yet, waiting..." >&2
  sleep 10
done
echo "Network is ready!"

apt update -y
apt install -y mariadb-server git curl awscli

systemctl start mariadb
systemctl enable mariadb

# Fetch password from SSM
REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
for i in {1..10}; do
  DATABASE_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" \
    --with-decryption --query "Parameter.Value" --output text --region $REGION 2>/dev/null) && break
  echo "SSM not ready yet, retrying ($i/10)..." >&2
  sleep 15
done

if [ -z "$DATABASE_PASS" ]; then
  echo "ERROR: Could not fetch DB password from SSM"
  exit 1
fi

echo "Configuring MariaDB..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS accounts;"
mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'localhost' IDENTIFIED BY '$DATABASE_PASS';"
mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY '$DATABASE_PASS';"
mysql -u root -e "FLUSH PRIVILEGES;"

echo "Cloning repo and restoring DB dump..."
for i in {1..5}; do
  git clone -b main https://github.com/amramer101/Strata-Ops.git /tmp/Strata-Ops && break
  echo "git clone failed, retrying ($i/5)..." >&2
  rm -rf /tmp/Strata-Ops
  sleep 15
done

mysql -u root accounts < /tmp/Strata-Ops/src/main/resources/db_backup.sql

echo "Verifying tables..."
mysql -u root accounts -e "SHOW TABLES;"
mysql -u root accounts -e "SELECT COUNT(*) as user_count FROM user;"

echo "MySQL Provisioning Completed Successfully!"