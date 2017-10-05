jenkins-terraform-triton
========================

Overview
- A terraform module that provisions a Jenkins master on Triton that is capable of creating ephemeral Jenkins slaves on Triton.

Networking Details
- This module creates a new VLAN and Fabric network to host internal master-slave Jenkins communication. The master and all slaves are attached to this internal network. The master can also have additional networks attached by defining the `master_additional_triton_network_names` variable.

Slave Docker Image Details
- The Jenkins master doesn't attempt to pull the specified slave Docker image, it is assumed to have been pulled and is available in Triton.
- The Jenkins master will provider 3 environment variables to the Docker image: JENKINS_URL, JENKINS_SECRET, JENKINS_AGENT_NAME.
- The Jenkins master expects the slave to connect using JNLP v4. A good base docker image is available [here](https://github.com/jenkinsci/docker-jnlp-slave).

Getting Started
- Checkout this project
- Modify example-cluster.tf or create your own
- `terraform init`
- `terraform plan`
- `terraform apply`

Known Limitations
- The Jenkins Docker plugin used to control the ephemeral slaves does not support Docker labels. Labels are needed to specify the Triton machine package to use. In the meantime we are limited to using the memory limit flag `-m`. e.g. `-m 2048` Triton will automatically select the smallest `g4-highcpu-*` package with enough memory for the specified limit. e.g. `g4-highcpu-2G`

Notes on Jenkins Docker plugin
- When implementing this module we tested the following docker plugins
	1. docker-plugin
	2. yet-another-docker-plugin
- Neither of the plugins support docker labels.
- Neither of the plugins allowed overriding of the port mapping when using the ssh launcher. This caused Triton to allocate a NIC on the Joyent-SDC-Public Network. Without the ability to override the triton.network.public network using a docker label, we where stuck with a publically accessible NIC attached to the instance.
- docker-plugin experimental JNLP launcher would not work.
- yet-another-docker-plugin JNLP launcher worked so we used it.