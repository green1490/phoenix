# configure cloudinit

data "template_file" "router_data" {
  // deprecated
  template = file("${path.module}/cloudinit/router.yml")
}


resource "libvirt_cloudinit_disk" "router_cloudinnit" {
  name      = "router.iso"
  user_data = data.template_file.router_data.rendered
}

# download alpine cloud image
resource "libvirt_volume" "alpine" {
  name   = "alpine"
  source = "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/cloud/nocloud_alpine-3.22.0-x86_64-bios-cloudinit-r0.qcow2"
}

resource "libvirt_volume" "master" {
  name = "master.qcow2"
  base_volume_id = libvirt_volume.alpine.id
}

resource "libvirt_domain" "router" {
  name = "router"
  disk {
    volume_id = libvirt_volume.master.id
  }
  cloudinit = libvirt_cloudinit_disk.router_cloudinnit.id
}
