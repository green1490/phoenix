resource "libvirt_volume" "master_volume" {
  name = "master_volume.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_domain" "master_domain" {
  name = "master"
  description = "Master node of the whole kubernetes cluster"
  vcpu = 2.0
  disk {
    volume_id = libvirt_volume.master_volume.id
  }
  cloudinit = libvirt_cloudinit_disk.cloudinit.id
  network_interface {
    network_id = libvirt_network.internal_network.id
    addresses = [ "192.168.200.1" ]
    wait_for_lease = true
  }

  provisioner "remote-exec" {
    connection {
      user = "k3s"
      host = self.network_interface[0].addresses[0]
      type = "ssh"
      private_key = file("~/.ssh/id_ed25519")
    }
    inline = [ 
      "curl -sfL https://get.k3s.io | sh -"
     ]
  }
}