resource "libvirt_volume" "router_volume" {
  name = "router.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_domain" "router" {
  name = "router"
  vcpu = 1
  disk {
    volume_id = libvirt_volume.router_volume.id
  }
  cloudinit = libvirt_cloudinit_disk.cloudinnit.id

  # external network
  # NIC 1
  network_interface {
    hostname = "router"
    network_id = libvirt_network.external_network.id
    addresses = [ "10.0.0.50" ]
    wait_for_lease = true
  }

  # NIC 2
  # internal network
  network_interface {
    hostname = "router"
    network_id = libvirt_network.internal_network.id
    addresses      = ["192.168.50.1"]
    wait_for_lease = true
  }
}
