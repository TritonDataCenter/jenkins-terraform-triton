#!/bin/bash
# THIS FILE MANAGED BY TERRAFORM

# Output logged to /var/log/mdata-user-script.log

# Get jenkins cli
wget -O jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# Initialize jenkins, first boot plugin install
java -jar jenkins-cli.jar http://localhost:8080 who-am-i --username admin --password $(cat /var/lib/jenkins/secrets/initialAdminPassword)

# Enable JNLP v4, disable all other JNLP

# Install yet-another-docker-plugin

# Configure yet-another-docker-plugin

# Cleanup
rm jenkins-cli.jar