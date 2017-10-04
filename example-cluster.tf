module "example-cluster" {
  source = "./modules/jenkins-master"

  name = "example-cluster"

  triton_account          = "user@domain.com"
  triton_key_path         = "~/.ssh/id_rsa"
  triton_key_id           = "68:9f:9a:c4:76:3a:f4:62:77:47:3e:47:d4:34:4a:b7"
  triton_url              = "https://us-west-1.api.joyentcloud.com"
  triton_docker_cert_path = "~/.sdc/docker/user@domain.com"

  additional_network_names = [
    "Joyent-SDC-Public",
  ]

  triton_vlan_id                   = 102
  triton_fabric_subnet             = "10.10.10.0/24"
  triton_fabric_provision_start_ip = "10.10.10.5"
  triton_fabric_provision_end_ip   = "10.10.10.253"

  triton_image_name      = "centos-7"
  triton_image_version   = "20161213"
  triton_machine_package = "g4-highcpu-1G"
}
