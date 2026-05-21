#!/bin/bash
set -e

echo "Starting RabbitMQ Provisioning on Ubuntu 22.04..."

# Wait for network/NAT Gateway to be ready
echo "Waiting for network connectivity..."
until curl -s --max-time 5 http://archive.ubuntu.com > /dev/null 2>&1; do
  echo "Network not ready yet, waiting..." >&2
  sleep 10
done
echo "Network is ready!"

apt update -y

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
KV_NAME="eprofile-kv-spaincentral-01" 

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