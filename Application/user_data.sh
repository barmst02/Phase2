#!/bin/bash
#
export PATH=$PATH:/bin:/usr/bin:/usr/local/bin:
APP_USER='webapp'
#
# Install AWS SSM
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
#
# Install httpd
yum install httpd -y 
systemctl start httpd
#
HOSTNAME+$( hostname )
echo "<html><body><h1>Hello from Apache Web Server (HTTPD) running on ${HOSTNAME}!</h1></body></html>" > /var/www/html/index.html 
chmod 444 /var/www/html/index.html 
#
# Install git and python 
yum install git -y
yum install python -y
#
# Create Appplication user
useradd ${APP_USER} 
#
# Clone simple-webapp project
su - ${APP_USER} -c 'git clone https://github.com/pramodvp/simple_webapp.git'
#
# Load data to DynamoDB table: 
#su - ${APP_USER} -c "bash ~${APP_USER}/simple_webapp/dynamodb/load_data.sh"
~${APP_USER}/simple_webapp/dynamodb/load_data.sh
#
#Setup web app 
su - ${APP_USER} -c "bash ~${APP_USER}/simple_webapp/setup.sh" 
