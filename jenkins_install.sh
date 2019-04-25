#!/bin/bash

sudo su -

add-apt-repository ppa:webupd8team/java -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"
apt-add-repository "deb http://pkg.jenkins-ci.org/debian binary/"

apt-get update

apt-get install openjdk-8-jdk -y
apt-get install jenkins -y

jenkinsstatus=$(systemctl status jenkins.service | sed '7,$d')
echo -e " Jenkins status:\n\e[93m $jenkinsstatus"


jenkinspass=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
echo -e  "Jenkins Activation Password: \e[93m $jenkinpass"

ipaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/172.17.*//;s/10.0.*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo -e "Jenkins server adress: \e[93m $ipaddr:8080" 



