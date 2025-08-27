data "template_file" "agent_cloudinit" {
  template = file("${path.root}/cloudinit/agent.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "cloudinit.iso"
  user_data = data.template_file.agent_cloudinit.rendered
}