# run the following commands to complete the sonarqube process
# 1. Make the Script Executable:

chmod +x install_sonarqube.sh

# 2. Run the Script as Root:

sudo ./install_sonarqube.sh

# 3. Change the sonar user's shell:

sudo chsh -s /bin/bash sonar

# 4. Now log in as sonar:

sudo su - sonar

# 5. Navigate to the sonar.sh script diretory path

cd /opt/sonarqube/sonarqube-7.8/bin/linux-x86-64

# 6. Start sonarqube with the following command

sh sonar.sh start
# 7. check if sonarqube has started

sh sonar.sh status
# 8. Go to aws sonarqube instance security group and add the sonarqube 
# por: 9000
# connect and login to sonarqube with   ip:9000







UPDATE   UPDATE
After the running the script follow this process to start your sonarqube:

Correct Way to Start SonarQube (With Non-Login User)

Instead of switching users, do:

- run this command below:
sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh start


If You REALLY Want to Log in as sonar (Lab Only)
For learning or debugging only:
- run this command below
sudo usermod -s /bin/bash sonar
sudo su - sonar
- After that, your prompt will change to:
- run this:
cd   /opt/sonarqube/bin/linux-x86-64/
- then run this to start sonarqube
sh sonar.sh start
- run this to check is it started successfully
sh sonar.sh status


note:
Go to aws sonarqube instance security group and add the sonarqube 
port: 9000
connect and login to sonarqube with   ip:9000



























