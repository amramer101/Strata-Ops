#!/bin/bash
set -e

echo "Starting MySQL Provisioning on Ubuntu 22.04..."

# Wait for network connectivity
echo "Waiting for network connectivity..."
until curl -s --max-time 5 http://archive.ubuntu.com > /dev/null 2>&1; do
  echo "Network not ready yet, waiting..." >&2
  sleep 10
done
echo "Network is ready!"

apt update -y
apt install -y mariadb-server git curl jq

echo "Allowing external connections..."
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

systemctl restart mariadb
systemctl enable mariadb

# Fetch MySQL Credentials from Azure Key Vault
echo "Fetching Database Credentials from Azure Key Vault..."
KV_NAME="eprofile-kv-spain-01"

for i in {1..10}; do
  TOKEN=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq -r '.access_token')
  if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    DB_USER=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/mysql-username?api-version=7.1" | jq -r '.value')
    DB_PASS=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/mysql-password?api-version=7.1" | jq -r '.value')
    break
  fi
  echo "Key Vault not ready, retrying ($i/10)..." >&2
  sleep 15
done

if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
  echo "ERROR: Could not fetch DB credentials from Key Vault"
  exit 1
fi

# Configuring MariaDB with Dynamic Credentials
echo "Configuring MariaDB..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS accounts;"

mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u root -e "GRANT ALL PRIVILEGES ON accounts.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
mysql -u root -e "FLUSH PRIVILEGES;"

echo "Cloning repo and restoring DB dump..."
for i in {1..5}; do
  git clone -b main https://github.com/amramer101/Strata-Ops.git /tmp/Strata-Ops && break
  echo "git clone failed, retrying ($i/5)..." >&2
  rm -rf /tmp/Strata-Ops
  sleep 15
done

mysql -u root accounts < /tmp/Strata-Ops/src/main/resources/db_backup.sql

echo "MySQL Provisioning Completed Successfully!"