#!/bin/bash
set -e

echo "Starting Nexus Native Provisioning..."

# 1. Install Dependencies
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-17-amazon-corretto-devel wget jq aws-cli -y

# 2. Download and Setup Nexus
mkdir -p /opt/nexus/
mkdir -p /tmp/nexus/
cd /tmp/nexus/
NEXUSURL="https://download.sonatype.com/nexus/3/nexus-unix-x86-64-3.78.0-14.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
sleep 10
EXTOUT=$(tar xzvf nexus.tar.gz)
NEXUSDIR=$(echo $EXTOUT | cut -d '/' -f1)
sleep 5
rm -rf /tmp/nexus/nexus.tar.gz
cp -r /tmp/nexus/* /opt/nexus/
sleep 5

# 3. Create User and Permissions
useradd nexus
chown -R nexus:nexus /opt/nexus

# 4. Configure Systemd Service
cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc
systemctl daemon-reload
systemctl enable nexus
systemctl start nexus

# ==============================================================================
# 5. AUTOMATION: Password Extraction, Update & SSM Injection
# ==============================================================================

echo "Waiting for Nexus to start (This usually takes 2-3 minutes)..."

while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8081/)" != "200" ]]; do
  sleep 10
done

echo "Nexus is UP! Processing passwords..."

INITIAL_PASSWORD_FILE="/opt/nexus/sonatype-work/nexus3/admin.password"

if [ -f "$INITIAL_PASSWORD_FILE" ]; then
    INITIAL_PASS=$(cat $INITIAL_PASSWORD_FILE)
    
    NEW_NEXUS_PASS="admin123"

    curl -u "admin:$INITIAL_PASS" \
         -X PUT \
         -H 'Content-Type: text/plain' \
         -H 'accept: application/json' \
         --data "$NEW_NEXUS_PASS" \
         http://localhost:8081/service/rest/v1/security/users/admin/change-password
    
    echo "Password changed successfully."

    aws ssm put-parameter \
      --name "/strata-ops/nexus-password" \
      --value "$NEW_NEXUS_PASS" \
      --type "SecureString" \
      --overwrite \
      --region eu-central-1

    echo "Nexus password successfully injected into AWS SSM."
else
    echo "ERROR: Initial password file not found."
fi

echo "Nexus Provisioning Completed!"