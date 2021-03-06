#!/bin/bash

sudo su -

#Updating packages list
apt-get update

#Install packages to allow apt to use a repository over HTTPS:
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

#Set enviromental variables
DOCKER_EE_VERSION=18.09
DOCKER_EE_URL="https://storebits.docker.com/ee/ubuntu/sub-e57bb6c2-563e-453b-ae20-9f018c7fbef5"

#Add the Docker repository
curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | apt-key add -
apt-key fingerprint 6D085F96
add-apt-repository "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu $(lsb_release -cs) stable-$DOCKER_EE_VERSION"

#Updating packages list
apt-get update

#Install Docker EE
apt-get install -y docker-ee docker-ee-cli containerd.io

#Add user to group docker
usermod -aG docker $USER

#Test Docker
docker run hello-world

#Install Docker-compose
apt-get install -y docker-compose

#Get Docker status
dockerstatus=$(systemctl status docker.service | sed '7,$d')
echo -e " Docker status:\n\e[93m $dockerstatus"

