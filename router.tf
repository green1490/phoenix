# configure cloudinit

data "template_file" "router_data" {
  // deprecated
  template = file("${path.module}/cloudinit/router.yml")
}


resource "libvirt_cloudinit_disk" "router_cloudinnit" {
  name      = "router.iso"
  user_data = data.template_file.router_data.rendered
}

# download opensuse cloud image
resource "libvirt_volume" "opensuse" {
  name   = "opensuse"
  source = "/var/lib/libvirt/images/openSUSE.qcow2"
}

resource "libvirt_volume" "master" {
  name = "master.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_network" "router_network" {
  name = "router_network"
  addresses = ["10.0.0.0/8", ]
}

resource "libvirt_domain" "router" {
  name = "router"
  disk {
    volume_id = libvirt_volume.master.id
  }
  cloudinit = libvirt_cloudinit_disk.router_cloudinnit.id

  network_interface {
    network_id = libvirt_network.router_network.id
    hostname = "router"
    addresses = [ "10.0.0.50" ]
    wait_for_lease = true
  }
}
