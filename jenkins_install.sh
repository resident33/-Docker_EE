#!/bin/bash

sudo su -

add-apt-repository ppa:webupd8team/java -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"
apt-add-repository "deb http://pkg.jenkins-ci.org/debian binary/"

apt-get update

apt-get install openjdk-8-jdk -y
apt-get install jenkins -y

JenkinsPass=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
java -version
