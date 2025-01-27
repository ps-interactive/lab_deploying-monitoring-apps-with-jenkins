#!/bin/bash

## This script is used to setup the lab environment and get all the required credentials needed.

# Generate the ssh key for pslearner user
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

# Git Server Setup
echo -e "Setting up the local Git Server.....\n"
sudo useradd -m -p $(openssl passwd -5 'password1') git
su git
mkdir .ssh && chmod 700 .ssh
sudo mkdir /usr/local/git
sudo chown git:git /usr/local/git



su git
cd
mkdir .ssh && chmod 700 .ssh
touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys


# Start the Docker containers
cd ~
mkdir jenkins_home
mkdir jenkins_home/plugins
cp -R lab/plugins/* jenkins_home/plugins/

# Jenkins
sudo docker run -p 8080:8080 -p 50000:50000 --restart=on-failure -v /home/pslearner/jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk17

# Prometheus
sudo docker run -p 9090:9090 -v /home/pslearner/lab/configs/prometheus.yml:/etc/prometheus/prometheus.yml -v /home/pslearner/prometheus-data:/prometheus prom/prometheus
    
# Grafana
sudo docker run -d --name grafana -p 3000:3000 grafana/grafana

# Nagios
sudo docker run --name nagios -p 0.0.0.0:8081:80 jasonrivers/nagios:latest	
