resource "libvirt_volume" "database_volume" {
  name = "database_volume.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_domain" "name" {
  name = "database"
  vcpu = 1
  disk {
    volume_id = libvirt_volume.database_volume.id
  }
  cloudinit = libvirt_cloudinit_disk.cloudinnit.id

  network_interface {
    network_id = libvirt_network.internal_network.id
    addresses = [ "192.168.150.1" ]
    wait_for_lease = true
  }
}