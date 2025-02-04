#!/bin/bash

# Variables
JENKINS_ADMIN_PASSWD=$(sudo cat /home/pslearner/jenkins_home/secrets/initialAdminPassword)

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
echo "Git user password is 'git'"
echo "Jenkins URL is 'http://localhost:3000'"
echo "Prometheus URL is 'http://localhost:9090'"
echo "Grafana URL is 'http://localhost:3000'"
echo "Nagios URL is 'http://localhost:8081'"
echo "Jenkins admin password is $JENKINS_ADMIN_PASSWD"
