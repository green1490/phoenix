output "master_ip_address" {
    description = "The ip address of the master node which is the control plane in the kubernetes cluster"
    value = libvirt_domain.master.network_interface[0].addresses
}