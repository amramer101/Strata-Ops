#!/bin/bash
set -e

echo "Starting RabbitMQ Provisioning on Ubuntu 22.04..."

apt update -y
apt install -y curl gnupg

# Install Erlang
curl -1sLf 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh' | bash
apt install -y erlang

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