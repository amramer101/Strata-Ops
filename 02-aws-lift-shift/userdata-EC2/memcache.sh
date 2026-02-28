#!/bin/bash
set -e

echo "Starting Memcached Provisioning on Ubuntu 22.04..."

# Wait for network/NAT Gateway to be ready
echo "Waiting for network connectivity..."
until curl -s --max-time 5 http://archive.ubuntu.com > /dev/null 2>&1; do
  echo "Network not ready yet, waiting..." >&2
  sleep 10
done
echo "Network is ready!"

apt update -y
apt install -y memcached

# Allow connections from all IPs
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/memcached.conf

systemctl enable memcached
systemctl restart memcached
systemctl status memcached

echo "Memcached Provisioning Completed!"