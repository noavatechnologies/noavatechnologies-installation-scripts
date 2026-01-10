#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update -y

# Install Java
echo "Installing default JDK..."
sudo apt install default-jdk -y

# Verify Java installation
echo "Verifying Java installation..."
java --version

# Change directory to /opt
echo "Changing directory to /opt..."
cd /opt

# Download Apache Maven
MAVEN_VERSION="3.9.12"
echo "Downloading Apache Maven version $MAVEN_VERSION..."
sudo wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz

# Extract the Maven package
echo "Extracting Apache Maven..."
sudo tar xf apache-maven-$MAVEN_VERSION-bin.tar.gz

# Rename and create a soft link
echo "Creating a soft link for Maven..."
sudo ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven

# Remove the Apache Maven tar file
echo "Removing the downloaded tar file..."
sudo rm -rf apache-maven-$MAVEN_VERSION-bin.tar.gz

# Perform Maven configuration
echo "Creating Maven environment configuration..."
sudo bash -c 'cat > /etc/profile.d/maven.sh << EOL
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64  # Update this path if it's different
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\${JAVA_HOME}/bin:\${M2_HOME}/bin:\${PATH} 
#EOL'

# Make the script executable
echo "Making the Maven configuration script executable..."
sudo chmod +x /etc/profile.d/maven.sh

# Load the environment variables
echo "Loading environment variables..."
source /etc/profile.d/maven.sh

# Verify Maven installation
echo "Verifying Maven installation..."
mvn --version

echo "If you see the Maven version information above, Maven has been successfully installed and configured!"

