resource "libvirt_volume" "webserver_volume" {
    name = "webserver.qcow2"
    base_volume_id = libvirt_volume.talos.id
}

resource "libvirt_domain" "webserver" {
    name = "webserver"
    vcpu = 1
    cpu {
        mode = "host-passthrough"
    }
    disk {
        volume_id = libvirt_volume.webserver_volume.id
    }
    network_interface {
        network_id = libvirt_network.internal_network.id
        addresses = [ "192.168.100.1" ]
        hostname = "webserver"
        wait_for_lease = true
    }
}