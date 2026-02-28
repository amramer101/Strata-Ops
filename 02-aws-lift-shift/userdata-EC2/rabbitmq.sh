#!/bin/bash
set -e

echo "Installing RabbitMQ for Amazon Linux 2..."

# Install Erlang first from EPEL
sudo yum install -y epel-release || true
sudo amazon-linux-extras install -y epel || true
sudo yum install -y erlang socat logrotate

# Add RabbitMQ repo for Amazon Linux 2
curl -o /tmp/rabbitmq.repo https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/awsliftandshift/al2rmq.repo || \
cat > /etc/yum.repos.d/rabbitmq.repo <<'EOF'
[rabbitmq-server]
name=rabbitmq-server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/$basearch
gpgcheck=0
enabled=1
EOF

sudo yum install -y rabbitmq-server

sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# Configure
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

sudo systemctl restart rabbitmq-server

echo "RabbitMQ Provisioning Completed!"