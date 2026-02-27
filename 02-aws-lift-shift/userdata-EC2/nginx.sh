#!/bin/bash
set -e
apt update
apt install nginx -y

until dig +short app01.eprofile.in | grep -q '.'; do
  sleep 5
done

TOMCAT_IP=$(dig +short app01.eprofile.in | tail -1)

cat <<EOT > /etc/nginx/sites-available/vproapp
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

mv vproapp /etc/nginx/sites-available/vproapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

#starting nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
