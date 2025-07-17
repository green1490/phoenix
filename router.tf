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
  source = "https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-OpenStack-Cloud.qcow2"
}

resource "libvirt_volume" "master" {
  name = "master.qcow2"
  base_volume_id = libvirt_volume.opensuse.id
}

resource "libvirt_network" "router_network" {
  name = "router_network"
  addresses = ["10.17.3.0/24"]
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
  }
}
