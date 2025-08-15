data "template_file" "base_data" {
  template = file("${path.root}/cloudinit/base.yml")
}


resource "libvirt_cloudinit_disk" "cloudinnit" {
  name      = "router.iso"
  user_data = data.template_file.base_data.rendered
}