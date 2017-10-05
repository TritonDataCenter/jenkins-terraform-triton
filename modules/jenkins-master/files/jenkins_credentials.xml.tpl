<?xml version='1.0' encoding='UTF-8'?>
<com.cloudbees.plugins.credentials.SystemCredentialsProvider plugin="credentials@2.1.16">
  <domainCredentialsMap class="hudson.util.CopyOnWriteMap$Hash">
    <entry>
      <com.cloudbees.plugins.credentials.domains.Domain>
        <specifications/>
      </com.cloudbees.plugins.credentials.domains.Domain>
      <java.util.concurrent.CopyOnWriteArrayList>
        <org.jenkinsci.plugins.docker.commons.credentials.DockerServerCredentials plugin="docker-commons@1.8">
          <scope>GLOBAL</scope>
          <id>a9c3efd8-0ce8-4272-b499-0b9e7432f3e2</id>
          <description>${name} triton credentials</description>
          <clientKey>${triton_docker_client_key}</clientKey>
          <clientCertificate>${triton_docker_client_cert}</clientCertificate>
          <serverCaCertificate>${triton_docker_server_ca_cert}</serverCaCertificate>
        </org.jenkinsci.plugins.docker.commons.credentials.DockerServerCredentials>
      </java.util.concurrent.CopyOnWriteArrayList>
    </entry>
  </domainCredentialsMap>
</com.cloudbees.plugins.credentials.SystemCredentialsProvider>