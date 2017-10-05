<com.github.kostyasha.yad.DockerCloud plugin="yet-another-docker-plugin@0.1.0-rc42">
  <name>${name}-triton</name>
  <provisionedImages/>
  <templates>
    <com.github.kostyasha.yad.DockerSlaveTemplate>
      <id>7550adca-52aa-4f03-9031-07725abf4635</id>
      <labelString>triton</labelString>
      <launcher class="com.github.kostyasha.yad.launcher.DockerComputerJNLPLauncher">
        <launchTimeout>120</launchTimeout>
        <user>jenkins</user>
        <jvmOpts></jvmOpts>
        <slaveOpts>-workDir /home/jenkins</slaveOpts>
        <jenkinsUrl>DETERMINED_ON_INSTALL</jenkinsUrl>
        <noCertificateCheck>false</noCertificateCheck>
        <reconnect>false</reconnect>
      </launcher>
      <remoteFs>/home/jenkins</remoteFs>
      <mode>NORMAL</mode>
      <retentionStrategy class="com.github.kostyasha.yad.strategy.DockerOnceRetentionStrategy">
        <idleMinutes>10</idleMinutes>
        <idleMinutes defined-in="com.github.kostyasha.yad.strategy.DockerOnceRetentionStrategy">10</idleMinutes>
      </retentionStrategy>
      <numExecutors>1</numExecutors>
      <dockerContainerLifecycle>
        <image>${slave_triton_image_name}:${slave_triton_image_version}</image>
        <pullImage>
          <pullStrategy>PULL_NEVER</pullStrategy>
          <credentialsId></credentialsId>
        </pullImage>
        <createContainer>
          <command></command>
          <hostname></hostname>
          <dnsHosts class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </dnsHosts>
          <volumes class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </volumes>
          <volumesFrom class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </volumesFrom>
          <environment class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </environment>
          <bindPorts></bindPorts>
          <bindAllPorts>false</bindAllPorts>
          <memoryLimit>0</memoryLimit>
          <privileged>false</privileged>
          <tty>false</tty>
          <extraHosts class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </extraHosts>
          <networkMode>${name}-jenkins-internal</networkMode>
          <devices class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </devices>
          <cpusetCpus></cpusetCpus>
          <cpusetMems></cpusetMems>
          <links class="java.util.Collections$UnmodifiableRandomAccessList" resolves-to="java.util.Collections$UnmodifiableList">
            <c class="list"/>
            <list reference="../c"/>
          </links>
          <shmSize>0</shmSize>
          <restartPolicy>
            <policyName>NO</policyName>
            <maximumRetryCount>0</maximumRetryCount>
          </restartPolicy>
          <workdir></workdir>
          <user></user>
        </createContainer>
        <stopContainer>
          <timeout>10</timeout>
        </stopContainer>
        <removeContainer>
          <removeVolumes>true</removeVolumes>
          <force>true</force>
        </removeContainer>
      </dockerContainerLifecycle>
      <maxCapacity>10</maxCapacity>
    </com.github.kostyasha.yad.DockerSlaveTemplate>
  </templates>
  <containerCap>50</containerCap>
  <connector>
    <serverUrl>${triton_docker_url}</serverUrl>
    <apiVersion>1.24</apiVersion>
    <credentialsId>a9c3efd8-0ce8-4272-b499-0b9e7432f3e2</credentialsId>
    <connectorType>NETTY</connectorType>
    <connectTimeout>5</connectTimeout>
    <readTimeout>5</readTimeout>
  </connector>
</com.github.kostyasha.yad.DockerCloud>