resource "libvirt_volume" "webserver_volume" {
    name = "webserver.qcow2"
    base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_domain" "webserver_domain" {
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
    depends_on = [ 
        libvirt_domain.master_domain
     ]
    provisioner "file" {
        connection {
            user = "k3s"
            host = self.network_interface[0].addresses[0]
            private_key = file("~/.ssh/id_ed25519")
            type = "ssh"
        }
        source = "/var/lib/rancher/k3s/server/node-token"
        destination = "/tmp/token.txt"
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            host = self.network_interface[0].addresses[0]
            private_key = file("~/.ssh/id_ed25519")
            user = "k3s"
        }
        inline = [ 
            "curl -sfL https://get.k3s.io | K3S_URL=$(cat /tmp/token.txt) sh -"
        ]
    }
}