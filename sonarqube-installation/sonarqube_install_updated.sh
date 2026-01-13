#!/bin/bash
set -e

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with root privileges. Try: sudo $0"
    exit 1
fi

echo "Updating package index..."
apt update

echo "Installing OpenJDK 17, unzip, and wget..."
apt install -y openjdk-17-jdk unzip wget

echo "Verifying Java installation..."
java -version

# Kernel parameters required by SonarQube
echo "Configuring system limits..."
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

echo "Creating sonar system user..."
id sonar &>/dev/null || useradd -r -m -d /opt/sonarqube -s /bin/false sonar

# Define SonarQube variables
SONAR_VERSION="9.9.3.79811"
SONAR_TARBALL="sonarqube-$SONAR_VERSION.zip"
SONAR_URL="https://binaries.sonarsource.com/Distribution/sonarqube/$SONAR_TARBALL"

echo "Downloading SonarQube $SONAR_VERSION..."
cd /tmp
wget -q $SONAR_URL -O $SONAR_TARBALL

echo "Extracting SonarQube..."
unzip -q $SONAR_TARBALL

echo "Moving SonarQube to /opt/sonarqube..."
rm -rf /opt/sonarqube
mv "sonarqube-$SONAR_VERSION" /opt/sonarqube

echo "Setting ownership..."
chown -R sonar:sonar /opt/sonarqube

# Explicitly configure Java 17 for SonarQube
echo "Setting JAVA_HOME for SonarQube..."
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /opt/sonarqube/bin/linux-x86-64/sonar.sh

# Cleanup
rm -f /tmp/$SONAR_TARBALL

echo "Installation completed successfully!"
echo "-----------------------------------"
echo "Next Steps:"
echo "1. Switch to sonar user:"
echo "   sudo su - sonar"
echo ""
echo "2. Start SonarQube:"
echo "   cd /opt/sonarqube/bin/linux-x86-64"
echo "   ./sonar.sh start"
echo ""
echo "3. Access SonarQube:"
echo "   http://<SERVER-IP>:9000"
echo "-----------------------------------"
