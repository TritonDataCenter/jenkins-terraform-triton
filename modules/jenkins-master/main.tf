variable "name" {
  description = "Human readable name used as prefix to randomly generated names"
}

variable "triton_account" {
  description = "The Triton account name, usually the username of your root user."
}

variable "triton_key_path" {
  description = "The path to a private key that is authorized to communicate with the Triton API."
}

variable "triton_key_id" {
  description = "The md5 fingerprint of the key at triton_key_path. Obtained by running `ssh-keygen -E md5 -lf ~/path/to.key`"
}

variable "triton_url" {
  description = "The CloudAPI endpoint URL. e.g. https://us-west-1.api.joyent.com"
}

variable "triton_docker_url" {
  description = "The Docker Remote API URL for Triton. e.g. tcp://us-west-1.docker.joyent.com:2376"
}

variable "triton_docker_cert_path" {
  description = "The path to the folder outputed by sdc-docker-setup.sh"
}

variable "triton_vlan_id" {
  description = "The VLAN ID to use when creating the Jenkins internal (master-slave) VLAN. Number between 0-4095 and not in use by another VLAN."
}

variable "triton_fabric_subnet" {
  description = "CIDR formatted string describing the Jenkins internal (master-slave) network. e.g. 10.10.10.0/24"
}

variable "triton_fabric_provision_start_ip" {
  description = "The first IP on the Jenkins internal (master-slave) network that can be assigned. e.g. 10.10.10.5"
}

variable "triton_fabric_provision_end_ip" {
  description = "The last IP on the Jenkins internal (master-slave) network that can be assigned. e.g. 10.10.10.253"
}

variable "master_additional_triton_network_names" {
  type        = "list"
  description = "List of Triton network names that the Jenkins master node should be attached to."
}

variable "master_triton_image_name" {
  description = "The name of the Triton image to use for the Jenkins master node."
}

variable "master_triton_image_version" {
  description = "The version/tag of the Triton image to use for the Jenkins master node."
}

variable "master_triton_machine_package" {
  description = "The Triton machine package to use for the Jenkins master node. e.g. g4-highcpu-1G"
}

variable "slave_triton_image_name" {
  description = "The name of the Triton image to use for the Jenkins slave nodes."
}

variable "slave_triton_image_version" {
  description = "The version/tag of the Triton image to use for the Jenkins slave nodes."
}

variable "slave_triton_machine_package" {
  description = "The Triton machine package to use for the Jenkins slave nodes. e.g. g4-highcpu-1G"
}

provider "triton" {
  account      = "${var.triton_account}"
  key_material = "${file(var.triton_key_path)}"
  key_id       = "${var.triton_key_id}"
  url          = "${var.triton_url}"
}

resource "triton_vlan" "jenkins-vlan" {
  vlan_id     = "${var.triton_vlan_id}"
  name        = "${var.name}-jenkins-vlan"
  description = "VLAN for internal (master-slave) Jenkins communication."
}

resource "triton_fabric" "jenkins-internal" {
  vlan_id            = "${var.triton_vlan_id}"
  name               = "${var.name}-jenkins-internal"
  description        = "Network for internal (master-slave) Jenkins communication."
  subnet             = "${var.triton_fabric_subnet}"
  provision_start_ip = "${var.triton_fabric_provision_start_ip}"
  provision_end_ip   = "${var.triton_fabric_provision_end_ip}"
  resolvers          = []

  internet_nat = false
}

data "triton_network" "additional_networks" {
  count = "${length(var.master_additional_triton_network_names)}"
  name  = "${element(var.master_additional_triton_network_names, count.index)}"
}

data "triton_image" "master" {
  name    = "${var.master_triton_image_name}"
  version = "${var.master_triton_image_version}"
}

data "template_file" "jenkins_credentials" {
  template = "${file("${path.module}/files/jenkins_credentials.xml.tpl")}"

  vars {
    name                         = "${var.name}"
    triton_docker_client_key     = "${file("${var.triton_docker_cert_path}/key.pem")}"
    triton_docker_client_cert    = "${file("${var.triton_docker_cert_path}/cert.pem")}"
    triton_docker_server_ca_cert = "${file("${var.triton_docker_cert_path}/ca.pem")}"
  }
}

data "template_file" "yet-another-docker-plugin_config" {
  template = "${file("${path.module}/files/yet-another-docker-plugin_config.xml.tpl")}"

  vars {
    name                       = "${var.name}"
    slave_triton_image_name    = "${var.slave_triton_image_name}"
    slave_triton_image_version = "${var.slave_triton_image_version}"
    triton_docker_url          = "${var.triton_docker_url}"
  }
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "credentials.xml"
    content_type = "text/xml"
    content      = "${data.template_file.jenkins_credentials.rendered}"
  }

  part {
    filename     = "yet-another-docker-plugin_config.xml"
    content_type = "text/xml"
    content      = "${data.template_file.yet-another-docker-plugin_config.rendered}"
  }

  part {
    filename     = "jenkins_config.xsl"
    content_type = "text/xml"
    content      = "${file("${path.module}/files/jenkins_config.xsl")}"
  }
}

resource "triton_machine" "jenkins-master" {
  package = "${var.master_triton_machine_package}"
  image   = "${data.triton_image.master.id}"
  name    = "${var.name}-jenkins-master"

  user_data   = "${data.template_cloudinit_config.config.rendered}"
  user_script = "${file("${path.module}/files/install_jenkins.sh")}"

  networks = ["${concat(
    list(triton_fabric.jenkins-internal.id),
    data.triton_network.additional_networks.*.id,
  )}"]
}
