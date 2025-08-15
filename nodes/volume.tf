resource "libvirt_volume" "opensuse" {
  name   = "opensuse"
  source = "/var/lib/libvirt/images/openSUSE.qcow2"
}