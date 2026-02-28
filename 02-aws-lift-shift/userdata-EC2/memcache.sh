#!/bin/bash
set -e

echo "Starting Memcached Provisioning on Ubuntu 22.04..."

apt update -y
apt install -y memcached

# Allow connections from all IPs
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/memcached.conf

systemctl enable memcached
systemctl restart memcached
systemctl status memcached

echo "Memcached Provisioning Completed!"