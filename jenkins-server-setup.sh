#!/bin/bash

# install jenkins

sudo yum update –y
sudo sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y

sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

# then install git
sudo yum install git -y
