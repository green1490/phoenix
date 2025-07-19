# configure cloudinit

data "template_file" "router_data" {
  // deprecated
  template = file("${path.module}/cloudinit/base.yml")
}


resource "libvirt_cloudinit_disk" "cloudinnit" {
  name      = "router.iso"
  user_data = data.template_file.router_data.rendered
}

# download opensuse cloud image
resource "libvirt_volume" "opensuse" {
  name   = "opensuse"
  source = "/var/lib/libvirt/images/openSUSE.qcow2"
}

resource "libvirt_volume" "router_volume" {
  name = "router.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_network" "router_network" {
  name = "router_network"
  addresses = ["10.0.0.0/8"]
}

resource "libvirt_domain" "router" {
  name = "router"
  disk {
    volume_id = libvirt_volume.router_volume.id
  }
  cloudinit = libvirt_cloudinit_disk.cloudinnit.id

  # NIC 1
  network_interface {
    hostname = "router"
    network_id = libvirt_network.router_network.id
    addresses = [ "10.0.0.50" ]
    wait_for_lease = true
  }

  # NIC 2
  # webserver's network
  network_interface {
    hostname = "router"
    network_id     = libvirt_network.webserver_network.id 
    addresses      = ["192.168.0.1"]
    wait_for_lease = true
  }
}
