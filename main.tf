terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

data "template_file" "base_data" {
  // deprecated
  template = file("${path.module}/cloudinit/base.yml")
}


resource "libvirt_cloudinit_disk" "cloudinnit" {
  name      = "router.iso"
  user_data = data.template_file.base_data.rendered
}

resource "libvirt_volume" "opensuse" {
  name   = "opensuse"
  source = "/var/lib/libvirt/images/openSUSE.qcow2"
}

resource "libvirt_network" "external_network" {
  name = "external_network"
  addresses = ["10.0.0.0/8"]
}

resource "libvirt_network" "internal_network" {
  name = "internal network"
  addresses = ["192.168.0.0/16"]
}