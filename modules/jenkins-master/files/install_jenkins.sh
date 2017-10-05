#!/bin/bash
# Output logged to /var/log/mdata-user-script.log
set -o xtrace

# Uncompress and split multipart user-data
cat <<EOF > decode_multipart.py
import sys
import email

message = sys.stdin.read()
msg = email.message_from_string(message)
for part in msg.walk():
        if part.get_filename() is None:
                continue
        open(part.get_filename(), 'wb').write(part.get_payload(decode=True))
EOF
cat /var/db/mdata-user-data | base64 --decode | gunzip | python decode_multipart.py
rm -f decode_multipart.py

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

# Wait for Jenkins to boot and update plugins list.
printf 'Waiting for Jenkins to start'
until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar); do
    printf '.'
    sleep 5
done

# Get Jenkins cli
wget -O jenkins-cli.jar http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar

# Install yet-another-docker-plugin
java -jar jenkins-cli.jar \
	-s http://127.0.0.1:8080 \
	-auth admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword) \
install-plugin yet-another-docker-plugin

# Install xmlstarlet to modify Jenkins config.xml
yum install -y epel-release
yum install -y xmlstarlet

# Inject Jenkins internal ip
# TODO: There is no guarantee that eth0 will be the internal jenkins network,
# we should loop through all ips and find the one in the matching subnet.
internal_ip=$(ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $3 }')
xmlstarlet ed \
	--inplace \
	-u 'com.github.kostyasha.yad.DockerCloud/templates/com.github.kostyasha.yad.DockerSlaveTemplate/launcher/jenkinsUrl' \
	-v "http://$internal_ip:8080" \
	yet-another-docker-plugin_config.xml

# Modify Jenkins config.xml using XSL
cat /var/lib/jenkins/config.xml | xmlstarlet tr jenkins_config.xsl > config.xml

mv config.xml /var/lib/jenkins/config.xml

# Move Jenkins credentials.xml
mv credentials.xml /var/lib/jenkins/credentials.xml

# Cleanup
rm -f jenkins_config.xsl
rm -f yet-another-docker-plugin_config.xml
rm -f jenkins-cli.jar

# Restart Jenkins
systemctl restart jenkins