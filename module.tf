module "nodes" {
    source = "./nodes"
}

module "talos" {
    source = "./talos"
    depends_on = [ module.nodes ]
}