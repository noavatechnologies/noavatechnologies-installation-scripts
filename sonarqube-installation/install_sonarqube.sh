#!/bin/bash
set -e

# Ensure the script is run as root.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with root privileges. Try: sudo $0"
    exit 1
fi

echo "Updating package index..."
apt update

echo "Installing OpenJDK 11, unzip, and wget..."
apt install -y openjdk-11-jdk unzip wget

# Confirm Java 11 is installed
echo "Java version:"
java -version

echo "Creating sonar system user..."
useradd -r -m -d /opt/sonarqube -s /bin/false sonar

# Define variables for SonarQube version and download URL
SONAR_VERSION="7.8"
SONAR_TARBALL="sonarqube-$SONAR_VERSION.zip"
SONAR_URL="https://binaries.sonarsource.com/Distribution/sonarqube/$SONAR_TARBALL"

echo "Downloading SonarQube $SONAR_VERSION..."
cd /tmp
wget $SONAR_URL -O $SONAR_TARBALL

echo "Extracting SonarQube..."
unzip $SONAR_TARBALL

echo "Moving SonarQube to /opt/sonarqube..."
mv "sonarqube-$SONAR_VERSION" /opt/sonarqube

echo "Setting ownership of /opt/sonarqube to sonar user..."
chown -R sonar:sonar /opt/sonarqube

echo "Installation complete!"
echo "-------------------------"
echo "Next Steps:"
echo "1. Switch to the sonar user:             sudo su - sonar"
echo "2. Go to the SonarQube bin directory:       cd /opt/sonarqube/bin/linux-x86-64"
echo "3. Start SonarQube:                         sh sonar.sh start"
echo "-------------------------"
echo "Once started, you can access SonarQube via its web interface."

