provider "libvirt" {
    uri = "qemu:///system"
}

provider "kubernetes" {
  
}


module "nodes" {
  source = "./nodes"
}