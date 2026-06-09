#!/bin/bash
set -e

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with root privileges. Try: sudo $0"
    exit 1
fi

echo "Updating package index..."
apt update

echo "Installing OpenJDK 25, unzip, wget, and PostgreSQL..."
apt install -y openjdk-25-jdk unzip wget postgresql postgresql-contrib

# Confirm Java 25 is installed
echo "Java version:"
java -version

echo "Creating sonar system user..."
useradd -r -m -d /opt/sonarqube -s /bin/bash sonar || true

# Define variables for SonarQube version and download URL
SONAR_VERSION="10.6.0.92116"
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

echo "Setting ownership of /opt/sonarqube to sonar user..."
chown -R sonar:sonar /opt/sonarqube

# Configure PostgreSQL
echo "Configuring PostgreSQL for SonarQube..."
sudo -u postgres psql -c "CREATE DATABASE sonarqube;"
sudo -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'StrongPasswordHere';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"

# Update SonarQube configuration
echo "Updating sonar.properties..."
cat <<EOF >> /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=StrongPasswordHere
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
EOF

# Set JAVA_HOME explicitly
echo "export JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64" >> /opt/sonarqube/bin/linux-x86-64/sonar.sh
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /opt/sonarqube/bin/linux-x86-64/sonar.sh

# Apply system limits
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf
sysctl -p

echo "Installation complete!"
echo "-------------------------"
echo "Next Steps:"
echo "1. Start SonarQube as sonar user:   sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh start"
echo "2. Check status:                    sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh status"
echo "3. Access SonarQube:                http://<SERVER-IP>:9000"
echo "Default login: admin / admin"
echo "-------------------------"
