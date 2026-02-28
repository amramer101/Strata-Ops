#!/bin/bash
set -e

echo "Installing Memcached for Amazon Linux 2..."

sudo yum install -y memcached

sudo systemctl start memcached
sudo systemctl enable memcached

# Allow connections from all IPs (not just localhost)
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

sudo systemctl restart memcached
sudo systemctl status memcached

echo "Memcached Provisioning Completed!"