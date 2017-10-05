module "example-cluster" {
  source = "./modules/jenkins-master"

  name = "example-cluster"

  triton_account          = "user@domain.com"
  triton_key_path         = "~/.ssh/id_rsa"
  triton_key_id           = "68:9f:9a:c4:76:3a:f4:62:77:47:3e:47:d4:34:4a:b7"
  triton_url              = "https://us-west-1.api.joyentcloud.com"
  triton_docker_url       = "tcp://us-west-1.docker.joyent.com:2376"
  triton_docker_cert_path = "~/.sdc/docker/user@domain.com"

  triton_vlan_id                   = 103
  triton_fabric_subnet             = "192.168.1.0/24"
  triton_fabric_provision_start_ip = "192.168.1.5"
  triton_fabric_provision_end_ip   = "192.168.1.253"

  master_additional_triton_network_names = [
    "Joyent-SDC-Public",
  ]

  master_triton_image_name      = "centos-7"
  master_triton_image_version   = "20161213"
  master_triton_machine_package = "g4-highcpu-1G"

  slave_triton_image_name      = "jenkinsci/jnlp-slave"
  slave_triton_image_version   = "latest"
  slave_triton_machine_package = "g4-highcpu-1G"
}
