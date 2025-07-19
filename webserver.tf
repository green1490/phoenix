resource "libvirt_volume" "webserver_volume" {
    base_volume_id = libvirt_volume.opensuse.id
    name = "webserver.qcow2"
}

resource "libvirt_network" "webserver_network" {
    name = "Webserver network"
    addresses = [ "192.168.0.0/16" ]
}

resource "libvirt_domain" "webserver_domain" {
    name = "webserver"
    disk {
        volume_id = libvirt_volume.webserver_volume.id
    }
    cloudinit = libvirt_cloudinit_disk.cloudinnit.id
    network_interface {
        network_id = libvirt_network.webserver_network.id
        addresses = [ "192.168.100.1" ]
        hostname = "webserver"
        wait_for_lease = true
    }
}