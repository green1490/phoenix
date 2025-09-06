data "talos_client_configuration" "this" {
  cluster_name         = "infra"
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = var.worker_ip_addresses
}

data "talos_machine_configuration" "workers" {
  cluster_name     = "infra"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  cluster_endpoint = "https://${var.control_plane_ip_address}:6443"
}

resource "talos_machine_configuration_apply" "this" {
   depends_on = [
    talos_machine_bootstrap.this
  ]
  for_each = var.worker_ip_addresses
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.workers.machine_configuration
  node                        = each.key
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sdd"
        },
        time = {
          servers = ["pool.ntp.org"]
        }
      }
    })
  ]
}