resource "libvirt_network" "external_network" {
  name = "external_network"
  addresses = ["10.0.0.0/8"]
}

resource "libvirt_network" "internal_network" {
  name = "internal network"
  addresses = ["192.168.0.0/16"]
}