#!/bin/bash
set -e

echo "Starting Tomcat 10 & Java 21 Provisioning..."

apt update -y

# 1. Install Java 21 and AWS CLI
apt install -y openjdk-21-jdk awscli

# 2. Set JAVA_HOME system-wide
echo 'JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# 3. Create Tomcat User
id -u tomcat &>/dev/null || useradd -m -U -d /opt/tomcat10 -s /bin/false tomcat

# 4. Download and Install Tomcat 10
cd /tmp
TOMCAT_VERSION="10.1.19"
wget https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
mkdir -p /opt/tomcat10
tar xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat10 --strip-components=1

chown -R tomcat:tomcat /opt/tomcat10
chmod -R 755 /opt/tomcat10/bin

# 5. Fetch DB Password from SSM
REGION="eu-central-1"
echo "Fetching Database Password from AWS SSM..."
for i in {1..10}; do
  DB_PASS=$(aws ssm get-parameter --name "/strata-ops/mysql-password" \
    --with-decryption --query "Parameter.Value" --output text --region $REGION 2>/dev/null) && break
  echo "SSM not ready yet, retrying ($i/10)..." >&2
  sleep 15
done

if [ -z "$DB_PASS" ]; then
  echo "ERROR: Could not fetch DB password from SSM"
  exit 1
fi

# 6. Inject Environment Variables via setenv.sh
cat > /opt/tomcat10/bin/setenv.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export RDS_HOSTNAME=db01.eprofile.in
export RDS_PORT=3306
export RDS_DB_NAME=accounts
export RDS_USERNAME=admin
export RDS_PASSWORD=${DB_PASS}
export RABBITMQ_HOSTNAME=rmq01.eprofile.in
export MEMCACHED_HOSTNAME=mc01.eprofile.in
EOF

chmod +x /opt/tomcat10/bin/setenv.sh
chown tomcat:tomcat /opt/tomcat10/bin/setenv.sh

# 7. Create Systemd Service
cat > /etc/systemd/system/tomcat10.service <<EOF
[Unit]
Description=Apache Tomcat 10 Web Application Container
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat10/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat10"
Environment="CATALINA_BASE=/opt/tomcat10"
ExecStart=/opt/tomcat10/bin/startup.sh
ExecStop=/opt/tomcat10/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tomcat10
systemctl start tomcat10

sleep 10
systemctl is-active tomcat10 && echo "Tomcat 10 is UP!" || echo "Tomcat 10 FAILED!"
echo "Tomcat 10 Provisioning Completed Successfully!"