variable "name" {}

variable "additional_network_names" {
  type = "list"
}

variable "triton_account" {
  "description" = "The Triton account name, usually the username of your root user."
}

variable "triton_key_path" {
  "description" = "The path to a private key that is authorized to communicate with the Triton API."
}

variable "triton_key_id" {
  "description" = "The md5 fingerprint of the key. Obtained by running ssh-keygen -E md5 -lf ~/path/to.key"
}

variable "triton_url" {
  "description" = "The CloudAPI endpoint URL. e.g. https://us-west-1.api.joyent.com"
}

variable "triton_docker_cert_path" {
  "description" = "The path to the folder outputed by sdc-docker-setup.sh"
}

variable "triton_image_name" {}
variable "triton_image_version" {}

variable "triton_vlan_id" {}
variable "triton_fabric_subnet" {}
variable "triton_fabric_provision_start_ip" {}
variable "triton_fabric_provision_end_ip" {}

variable "triton_machine_package" {}

provider "triton" {
  account      = "${var.triton_account}"
  key_material = "${file(var.triton_key_path)}"
  key_id       = "${var.triton_key_id}"
  url          = "${var.triton_url}"
}

resource "triton_vlan" "jenkins-vlan" {
  vlan_id     = "${var.triton_vlan_id}"
  name        = "${var.name}-jenkins-vlan"
  description = "VLAN for internal Jenkins communication"
}

resource "triton_fabric" "jenkins-internal" {
  vlan_id            = "${var.triton_vlan_id}"
  name               = "${var.name}-jenkins-internal"
  description        = "Network for Internal (master-slave) Jenkins communication"
  subnet             = "${var.triton_fabric_subnet}"
  provision_start_ip = "${var.triton_fabric_provision_start_ip}"
  provision_end_ip   = "${var.triton_fabric_provision_end_ip}"
  resolvers          = []

  internet_nat = false
}

data "triton_network" "additional_networks" {
  count = "${length(var.additional_network_names)}"
  name  = "${element(var.additional_network_names, count.index)}"
}

data "triton_image" "image" {
  name    = "${var.triton_image_name}"
  version = "${var.triton_image_version}"
}

data "template_file" "init" {
  template = "${file("${path.module}/files/install_jenkins.sh.tpl")}"

  vars {}
}

resource "triton_machine" "jenkins-master" {
  package = "${var.triton_machine_package}"
  image   = "${data.triton_image.image.id}"
  name    = "${var.name}-jenkins-master"

  user_script = "${data.template_file.init.rendered}"

  networks = ["${concat(
    list(triton_fabric.jenkins-internal.id),
    data.triton_network.additional_networks.*.id,
  )}"]
}
