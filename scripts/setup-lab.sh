#!/bin/bash

# Variables
JENKINS_ADMIN_PASSWD=$(sudo cat /home/pslearner/jenkins_home/secrets/initialAdminPassword)
JENKINS_IP=`sudo docker inspect $(sudo docker ps -a | grep jenkins | awk '{print $1}') | grep IPAddress | cut -d":" -f 2 | grep -v null | uniq | cut -d'"' -f 2`
PROMETHEUS_IP=`sudo docker inspect $(sudo docker ps -a | grep prometheus | awk '{print $1}') | grep IPAddress | cut -d":" -f 2 | grep -v null | uniq | cut -d'"' -f 2`
GRAFANA_IP=`sudo docker inspect $(sudo docker ps -a | grep grafana | awk '{print $1}') | grep IPAddress | cut -d":" -f 2 | grep -v null | uniq | cut -d'"' -f 2`
NAGIOS_IP=`sudo docker inspect $(sudo docker ps -a | grep nagios | awk '{print $1}') | grep IPAddress | cut -d":" -f 2 | grep -v null | uniq | cut -d'"' -f 2`

## Setting up the lab and retrieving the credentials.

# Clone your got repo
echo "Your git repo has be cloned using 'git clone git@localhost:/home/git/repositories/cicd-jenkins.git' to /home/pslearner/cicd-jenkins"
git clone git@localhost:/home/git/repositories/cicd-jenkins.git

# Set the global variables for git
git config --global user.email "pslearner@example.com"
git config --global user.name "PSLearner"

echo "Your Git configs for user email and name have been set to email - pslearner@example.com and name - PSLearner"

# Credentials listing
# Git
echo "++++++++++++++++++++++++++++++++++++++++++++++++"
echo "++         LAB DETAILS/CREDENTIALS            ++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++"   
echo ""
echo "Git user password is 'git'"
echo "Jenkins URL is 'http://$JENKINS_IP:3000'"
echo "Prometheus URL is 'http://$PROMETHEUS_IP:9090'"
echo "Grafana URL is 'http://$GRAFANA_IP:3000'"
echo "Nagios URL is 'http://$NAGIOS_IP:80'"
echo ""
echo "LAB LOGIN DETAILS"
echo "+++++++++++++++++"
echo "Jenkins admin password is $JENKINS_ADMIN_PASSWD"
echo "Grafana username/password is admin/admin. You can skip the password change"
echo "Nagios username/password is nagiosadmin/nagios."
