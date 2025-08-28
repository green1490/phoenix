resource "libvirt_volume" "webserver_volume" {
    name = "webserver.qcow2"
    base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_domain" "webserver" {
    name = "webserver"
    vcpu = 1
    disk {
        volume_id = libvirt_volume.webserver_volume.id
    }
    cloudinit = libvirt_cloudinit_disk.cloudinit.id
    network_interface {
        network_id = libvirt_network.internal_network.id
        addresses = [ "192.168.100.1" ]
        hostname = "webserver"
        wait_for_lease = true
    }
    depends_on = [ libvirt_domain.master ]
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            host = self.network_interface[0].addresses[0]
            private_key = file("~/.ssh/id_ed25519")
            user = "k3s"
        }
        inline = [ 
            "curl -sfL https://get.k3s.io | K3S_URL=https://${libvirt_domain.master.network_interface[0].addresses[0]} K3S_TOKEN=${random_string.k3s_token.result} sh -"
        ]
    }
}