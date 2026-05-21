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
KV_NAME="eprofile-kv-weurope-01"

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


apt install -y memcached

# Allow connections from all IPs
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/memcached.conf

systemctl enable memcached
systemctl restart memcached
systemctl status memcached

echo "Memcached Provisioning Completed!"



# Install Erlang (Ubuntu 22.04 native packages) and required tools
apt install -y \
  erlang-base \
  erlang-asn1 \
  erlang-crypto \
  erlang-eldap \
  erlang-ftp \
  erlang-inets \
  erlang-mnesia \
  erlang-os-mon \
  erlang-parsetools \
  erlang-public-key \
  erlang-runtime-tools \
  erlang-snmp \
  erlang-ssl \
  erlang-syntax-tools \
  erlang-tftp \
  erlang-tools \
  erlang-xmerl \
  jq curl zip unzip

# Install RabbitMQ
curl -1sLf 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/setup.deb.sh' | bash
apt install -y rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

#  Fetch RabbitMQ Credentials from Azure Key Vault
echo "Fetching RabbitMQ Credentials from Azure Key Vault..."
apt install -y jq curl
KV_NAME="eprofile-kv-weurope-01" 

for i in {1..10}; do
  TOKEN=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq -r '.access_token')
  if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    RMQ_USER=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/rabbitmq-username?api-version=7.1" | jq -r '.value')
    RMQ_PASS=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/rabbitmq-password?api-version=7.1" | jq -r '.value')
    break
  fi
  echo "Key Vault not ready, retrying ($i/10)..." >&2
  sleep 15
done

if [ -z "$RMQ_USER" ] || [ -z "$RMQ_PASS" ]; then
  echo "ERROR: Could not fetch RabbitMQ credentials from Key Vault"
  exit 1
fi


# Configure RabbitMQ
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

rabbitmqctl add_user "$RMQ_USER" "$RMQ_PASS"
rabbitmqctl set_user_tags "$RMQ_USER" administrator
rabbitmqctl set_permissions -p / "$RMQ_USER" ".*" ".*" ".*"

systemctl restart rabbitmq-server