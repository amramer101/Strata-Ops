#!/bin/bash
set -e

echo "Starting Tomcat 9 Provisioning..."

apt update -y
apt upgrade -y

# 1. Install Java First
apt install openjdk-17-jdk -y

# 2. Set JAVA_HOME system-wide
echo 'JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# 3. Install Tomcat after Java
apt install awscli tomcat9 tomcat9-admin tomcat9-common git -y

# 4. Set JAVA_HOME for systemd (so tomcat9.service can find Java)
mkdir -p /etc/systemd/system/tomcat9.service.d/
cat > /etc/systemd/system/tomcat9.service.d/override.conf <<EOF
[Service]
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
EOF

systemctl daemon-reload

# 5. Fetch DB Password from SSM
REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
DB_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" \
  --with-decryption --query "Parameter.Value" --output text --region $REGION)

# 6. Inject Environment Variables via setenv.sh
echo "Injecting Environment Variables..."
mkdir -p /usr/share/tomcat9/bin

cat > /usr/share/tomcat9/bin/setenv.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export RDS_HOSTNAME=db01.eprofile.in
export RDS_PORT=3306
export RDS_DB_NAME=accounts
export RDS_USERNAME=admin
export RDS_PASSWORD=${DB_PASS}
export RABBITMQ_HOSTNAME=rmq01.eprofile.in
export MEMCACHED_HOSTNAME=mc01.eprofile.in
EOF

chmod +x /usr/share/tomcat9/bin/setenv.sh
chown tomcat:tomcat /usr/share/tomcat9/bin/setenv.sh

# 7. Start Tomcat
systemctl enable tomcat9
systemctl restart tomcat9

# 8. Verify
sleep 10
systemctl is-active tomcat9 && echo "Tomcat is UP!" || echo "Tomcat FAILED - check logs!"

echo "Tomcat 9 Provisioning Completed!"