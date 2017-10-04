jenkins-terraform-triton
========================

Overview
- A terraform module that provisions a Jenkins master on Triton that is capable of creating ephemeral Jenkins slaves on Triton.

Networking Details
- This module creates a new VLAN and Fabric network to host internal master-slave Jenkins communication. The master and all slaves are attached to this internal network. The master can also have additional networks attached by defining the `additional_networks` variable.

Getting Started
- Checkout this project
- Modify example-cluster.tf or create your own
- `terraform init`
- `terraform plan`
- `terraform apply`

Known Limitations
- The Jenkins Docker plugin used to control the ephemeral slaves does not support Docker labels. Labels are needed to specify the Triton machine package to use. In the meantime we are limited to using the memory limit flag `-m`. e.g. `-m 2048` Triton will automatically select the smallest `g4-highcpu-*` package with enough memory for the specified limit. e.g. `g4-highcpu-2G`