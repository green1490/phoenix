resource "libvirt_volume" "master_volume" {
  name = "master_volume.qcow2"
  base_volume_id = libvirt_volume.talos.id
}

resource "libvirt_domain" "master" {
  name = "master"
  description = "Master node of the whole kubernetes cluster"
  vcpu = 2
  cpu {
    mode = "host-passthrough"
  }
  disk {
    volume_id = libvirt_volume.master_volume.id
  }
  network_interface {
    network_id = libvirt_network.internal_network.id
    addresses = [ "192.168.200.1" ]
    wait_for_lease = true
  }
}