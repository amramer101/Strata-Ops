#!/bin/bash
set -e

echo "Starting Nginx Provisioning on Ubuntu 22.04..."

apt update -y
apt install -y nginx dnsutils

# Wait for Tomcat DNS to resolve
echo "Waiting for app01.eprofile.in to resolve..."
until dig +short app01.eprofile.in | grep -q '.'; do
  echo "DNS not ready yet..." >&2
  sleep 5
done

TOMCAT_IP=$(dig +short app01.eprofile.in | tail -1)
echo "Tomcat IP resolved: $TOMCAT_IP"

# Write nginx config directly to the correct path (NO mv needed)
cat > /etc/nginx/sites-available/vproapp <<EOT
upstream vproapp {
  server ${TOMCAT_IP}:8080;
}
server {
  listen 80;
  location / {
    proxy_pass http://vproapp;
  }
}
EOT

# Enable vproapp and disable default
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

systemctl enable nginx
systemctl restart nginx

echo "Nginx Provisioning Completed!"