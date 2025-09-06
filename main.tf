terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }

    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

module "nodes" {
    source = "./modules/nodes"
}

module "talos" {
    source = "./modules/talos"
    control_plane_ip_address = module.nodes.master_ip_address
    worker_ip_addresses = toset([
      module.nodes.database_ip_address,
      module.nodes.router_ip_adress,
      module.nodes.webserver_ip_address
    ])
    depends_on = [ module.nodes ]
}