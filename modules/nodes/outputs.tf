output "master_ip_address" {
    description = "The ip address of the master node which is the control plane in the kubernetes cluster"
    value = libvirt_domain.master.network_interface[0].addresses[0]
}

output "webserver_ip_address" {
  value = libvirt_domain.webserver.network_interface[0].addresses[0]
}

output "router_ip_adress" {
  value = libvirt_domain.router.network_interface[0].addresses[0]
}

output "database_ip_address" {
  value = libvirt_domain.database.network_interface[0].addresses[0]
}