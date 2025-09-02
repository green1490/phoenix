resource "libvirt_volume" "database_volume" {
  name = "database_volume.qcow2"
  base_volume_id = libvirt_volume.talos.id
}

resource "libvirt_domain" "database" {
  name = "database"
  vcpu = 1
  cpu {
    mode = "host-passthrough"
  }
  
  disk {
    volume_id = libvirt_volume.database_volume.id
  }

  network_interface {
    network_id = libvirt_network.internal_network.id
    addresses = [ "192.168.150.1" ]
    wait_for_lease = true
  }
}