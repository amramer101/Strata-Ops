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

# Install Erlang (Ubuntu 22.04 native packages)
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
  erlang-xmerl

# Install RabbitMQ
curl -1sLf 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/setup.deb.sh' | bash
apt install -y rabbitmq-server

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

# Configure
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

systemctl restart rabbitmq-server
systemctl status rabbitmq-server

echo "RabbitMQ Provisioning Completed!"