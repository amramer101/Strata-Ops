#!/bin/bash
set -e

echo "Starting Nexus Native Provisioning..."

# 1. Install Dependencies
rpm --import https://yum.corretto.aws/corretto.key
curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
yum install -y java-17-amazon-corretto-devel wget jq aws-cli

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

# 4. Disable Onboarding Wizard (يحل مشكلة EULA تلقائياً)
NEXUS_PROPS="/opt/nexus/sonatype-work/nexus3/etc/nexus.properties"
mkdir -p "$(dirname $NEXUS_PROPS)"
eecho "nexus.onboarding.enabled=false" > "$NEXUS_PROPS"
echo "nexus.eula.accepted=true" >> "$NEXUS_PROPS"
chown -R nexus:nexus /opt/nexus/sonatype-work

# 5. Configure Systemd Service
cat > /etc/systemd/system/nexus.service <<EOT
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
# 6. Wait for Nexus to Start
# ==============================================================================

echo "Waiting for Nexus to start (usually 2-3 minutes)..."

while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8081/)" != "200" ]]; do
  echo "Still waiting..." >&2
  sleep 15
done

echo "Nexus is UP!"

# ==============================================================================
# 7. Change Admin Password & Push to SSM
# ==============================================================================

INITIAL_PASSWORD_FILE="/opt/nexus/sonatype-work/nexus3/admin.password"
NEW_NEXUS_PASS="admin123"

if [ ! -f "$INITIAL_PASSWORD_FILE" ]; then
    echo "ERROR: Initial password file not found."
    exit 1
fi

INITIAL_PASS=$(cat "$INITIAL_PASSWORD_FILE")

echo "Changing admin password..."
HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' \
  -u "admin:$INITIAL_PASS" \
  -X PUT \
  -H 'Content-Type: text/plain' \
  --data "$NEW_NEXUS_PASS" \
  "http://localhost:8081/service/rest/v1/security/users/admin/change-password")

if [[ "$HTTP_CODE" != "204" ]]; then
    echo "ERROR: Failed to change password. HTTP: $HTTP_CODE"
    exit 1
fi

echo "Password changed successfully."

echo "Pushing Nexus password to SSM..."
aws ssm put-parameter \
  --name "/strata-ops/nexus-password" \
  --value "$NEW_NEXUS_PASS" \
  --type "SecureString" \
  --overwrite \
  --region eu-central-1

echo "Nexus password injected into SSM."

# ==============================================================================
# 8. Create Repositories
# ==============================================================================

echo "Creating Maven Hosted Repository (vprofile-repo)..."

curl -s -o /dev/null -w '%{http_code}' \
  -u "admin:$NEW_NEXUS_PASS" \
  -X POST "http://localhost:8081/service/rest/v1/repositories/maven/hosted" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "vprofile-repo",
    "online": true,
    "storage": {
      "blobStoreName": "default",
      "strictContentTypeValidation": true,
      "writePolicy": "ALLOW"
    },
    "maven": {
      "versionPolicy": "MIXED",
      "layoutPolicy": "STRICT"
    }
  }'

echo "Repositories created successfully!"
echo "Nexus Provisioning Completed!"


echo "Waiting for Nexus to start..."
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8081/)" != "200" ]]; do
  sleep 15
done

# Accept EULA via onboarding API
curl -s -u "admin:$INITIAL_PASS" -X POST \
  "http://localhost:8081/service/rest/v1/eula/accept" \
  -H "Content-Type: application/json"

# Complete onboarding wizard
curl -s -u "admin:$INITIAL_PASS" -X PUT \
  "http://localhost:8081/service/rest/v1/onboarding/complete" \
  -H "Content-Type: application/json"

# Change password
curl -s -u "admin:$INITIAL_PASS" -X PUT \
  -H 'Content-Type: text/plain' \
  --data "$NEW_NEXUS_PASS" \
  "http://localhost:8081/service/rest/v1/security/users/admin/change-password"