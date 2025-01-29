#!/bin/bash

## This script is used to setup the lab environment and get all the required credentials needed.

# Generate the ssh key for pslearner user
# ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

# Git Server Setup
# echo -e "Setting up the local Git Server.....\n"

# Creating the git user and all the necessary filesystem and permissions
# sudo useradd -m -p $(openssl passwd -5 'password1') git
# sudo su - git
# cd
# mkdir .ssh && chmod 700 .ssh
# touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
# mkdir repositories
# mkdir repositories/cicd-jenkins.git
# chmod -R 777 repositories

# Initializing the git repo
# cd repositories/cicd-jenkins.git
# git init --bare

# echo "Your git repo can be cloned using 'git clone git@localhost:/home/git/repositories/cicd-jenkins.git'"
git clone git@localhost:/home/git/repositories/cicd-jenkins.git
