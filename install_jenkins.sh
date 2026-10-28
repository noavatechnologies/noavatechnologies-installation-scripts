
#!/bin/bash
set -Eeuo pipefail

# Jenkins LTS automated installation for Ubuntu
# Java 21 | AWS EC2

if [[ "$EUID" -ne 0 ]]; then
    echo "Run this script with sudo: sudo bash install_jenkins.sh"
    exit 1
fi

echo "===================================="
echo " Starting Jenkins installation"
echo "===================================="

export DEBIAN_FRONTEND=noninteractive

echo "[1/6] Updating Ubuntu packages..."
apt-get update -y
apt-get upgrade -y

echo "[2/6] Installing Java 21 and dependencies..."
apt-get install -y fontconfig openjdk-21-jre curl wget

echo "Checking Java version..."
java -version

echo "[3/6] Adding the official Jenkins LTS repository..."
install -d -m 0755 /etc/apt/keyrings

wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

echo "[4/6] Installing Jenkins..."
apt-get update -y
apt-get install -y jenkins

echo "[5/6] Enabling and starting Jenkins..."
systemctl enable --now jenkins

echo "[6/6] Verifying Jenkins service..."
if systemctl is-active --quiet jenkins; then
    echo "SUCCESS: Jenkins is active and running."
else
    echo "ERROR: Jenkins failed to start."
    systemctl --no-pager --full status jenkins || true
    journalctl -u jenkins -n 50 --no-pager || true
    exit 1
fi

echo
echo "Java version:"
java -version

echo
echo "Jenkins service:"
systemctl is-active jenkins

echo
echo "Initial administrator password:"
if [[ -f /var/lib/jenkins/secrets/initialAdminPassword ]]; then
    cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Password file not available yet. Check Jenkins startup logs."
fi

echo
echo "===================================="
echo " Installation process completed"
echo "===================================="
echo "Next: Configure AWS Security Group access."
echo "Then visit: http://<EC2_PUBLIC_IP>:8080"
