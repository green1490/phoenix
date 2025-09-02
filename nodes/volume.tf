resource "libvirt_volume" "talos" {
  name   = "master.qcow2"
  source = "/var/lib/libvirt/images/talos.qcow2"
}