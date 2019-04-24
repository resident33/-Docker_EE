#!/bin/bash
sudo su -

apt update
apt upgrade -y
apt install -y  dnsutils mc nmap htop mtr wget
