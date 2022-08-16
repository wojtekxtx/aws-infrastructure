#!/bin/bash

sudo apt update -y
sudo apt install -y wget kitty-terminfo gnupg2

wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/postgresql.gpg
sudo apt-get update -y
wget -q https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb -O /tmp/ssm.deb
sudo dpkg -i /tmp/ssm.deb
sudo apt install -y postgresql-client
sudo apt upgrade -y
