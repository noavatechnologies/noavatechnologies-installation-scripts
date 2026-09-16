#!/bin/bash

# Update package index
sudo apt update

# 1. Install Java 21 (OpenJDK)
sudo apt install -y openjdk-21-jdk

# Verify Java installation
java -version

# 2. Install Maven 3.9.16
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.16/binaries/apache-maven-3.9.16-bin.tar.gz
sudo tar xf apache-maven-3.9.16-bin.tar.gz
sudo ln -s /opt/apache-maven-3.9.16 /opt/maven

# Optional cleanup
sudo rm apache-maven-3.9.16-bin.tar.gz

# 3. Configure Maven environment variables
sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\${M2_HOME}/bin:\${PATH}
EOF

# Make the script executable
sudo chmod +x /etc/profile.d/maven.sh

# Load the environment variables
source /etc/profile.d/maven.sh

# 4. Verify Maven installation
mvn -version


