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
    control_plane_ip_adress = module.nodes.master_ip_address[0]
    depends_on = [ module.nodes ]
}