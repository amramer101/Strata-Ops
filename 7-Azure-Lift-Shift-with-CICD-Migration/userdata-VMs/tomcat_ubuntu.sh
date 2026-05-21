#!/bin/bash
set -e

echo "Starting Tomcat 10 & Java 21 Provisioning..."

apt update -y
apt install -y openjdk-21-jdk jq curl

# 1. Set JAVA_HOME system-wide
echo 'JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# 2. Create Tomcat User
id -u tomcat &>/dev/null || useradd -m -U -d /opt/tomcat10 -s /bin/false tomcat

# 3. Download and Install Tomcat 10
cd /tmp
TOMCAT_VERSION="10.1.19"
wget -q https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
mkdir -p /opt/tomcat10
tar xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat10 --strip-components=1
chown -R tomcat:tomcat /opt/tomcat10
chmod -R 755 /opt/tomcat10/bin

# Fetch Credentials from Azure Key Vault (DB & RabbitMQ)
echo "Fetching Credentials from Azure Key Vault..."
KV_NAME="eprofile-kv-spain-01"

for i in {1..10}; do
  TOKEN=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq -r '.access_token')
  if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    DB_USER=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/mysql-username?api-version=7.1" | jq -r '.value')
    DB_PASS=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/mysql-password?api-version=7.1" | jq -r '.value')
    RMQ_USER=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/rabbitmq-username?api-version=7.1" | jq -r '.value')
    RMQ_PASS=$(curl -s -H "Authorization: Bearer $TOKEN" "https://${KV_NAME}.vault.azure.net/secrets/rabbitmq-password?api-version=7.1" | jq -r '.value')
    break
  fi
  echo "Key Vault not ready, retrying ($i/10)..." >&2
  sleep 15
done

if [ -z "$DB_PASS" ] || [ -z "$RMQ_PASS" ]; then
  echo "ERROR: Could not fetch secrets from Key Vault"
  exit 1
fi

# 4. Inject Environment Variables via setenv.sh
cat > /opt/tomcat10/bin/setenv.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export RDS_HOSTNAME=db.eprofile.local
export RDS_PORT=3306
export RDS_DB_NAME=accounts
export RDS_USERNAME=$DB_USER
export RDS_PASSWORD=$DB_PASS
export RABBITMQ_HOSTNAME=rabbitmq.eprofile.local
export RABBITMQ_USER=$RMQ_USER
export RABBITMQ_PASS=$RMQ_PASS
export MEMCACHED_HOSTNAME=memcached.eprofile.local
EOF

chmod +x /opt/tomcat10/bin/setenv.sh
chown tomcat:tomcat /opt/tomcat10/bin/setenv.sh

# 5. Create Systemd Service
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

echo "Tomcat 10 Provisioning Completed Successfully!"