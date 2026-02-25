#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt install openjdk-17-jdk -y

sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y


echo "Injecting Environment Variables for Stage 2..."
cat <<EOF > /usr/share/tomcat9/bin/setenv.sh
export RDS_HOSTNAME=db01.eprofile.in
export RABBITMQ_HOSTNAME=rmq01.eprofile.in
export MEMCACHED_HOSTNAME=mc01.eprofile.in
EOF

chmod +x /usr/share/tomcat9/bin/setenv.sh

sudo systemctl start tomcat10
sudo systemctl enable tomcat10
sudo systemctl restart tomcat10