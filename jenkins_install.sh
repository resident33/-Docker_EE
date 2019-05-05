#!/bin/bash

sudo su -

#Add repository for Jenkins and Java
add-apt-repository ppa:webupd8team/java -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"
apt-add-repository "deb http://pkg.jenkins-ci.org/debian binary/"

#Updating packages list
apt-get update

#Install Jenkins and Java
apt-get install openjdk-8-jdk -y
apt-get install jenkins -y

#Get Jenkins status
jenkinsstatus=$(systemctl status jenkins.service | sed '7,$d')
echo -e " Jenkins status:\n\e[93m $jenkinsstatus"

#Waiting for Jenkins to create the file
sleep 15s

#Get Jenkins activation password
jenkinspass=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
echo -e "Jenkins activation password: \e[93m $jenkinspass"

#Get Jenkins server adress
ipaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/172.17.*//;s/10.0.*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo -e "Jenkins server adress: \e[93m $ipaddr:8080" 



