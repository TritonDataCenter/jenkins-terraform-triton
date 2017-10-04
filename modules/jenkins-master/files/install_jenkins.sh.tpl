#!/bin/bash
# THIS FILE MANAGED BY TERRAFORM

# Output logged to /var/log/mdata-user-script.log

yum update -y

# Install JDK 8
yum install -y java-1.8.0-openjdk

# Intsall latest LTS Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins

# Start Jenkins on system boot
chkconfig jenkins on

# Start Jenkins
systemctl start jenkins