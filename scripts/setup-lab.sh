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

