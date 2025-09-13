data "talos_machine_configuration" "workers" {
  cluster_name     = "infra"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.secret.machine_secrets
  cluster_endpoint = "https://${var.control_plane_ip_address}:6443"
}

data "talos_client_configuration" "workers" {
  cluster_name         = "infra"
  client_configuration = talos_machine_secrets.secret.client_configuration
  nodes                = var.worker_ip_addresses
}

resource "talos_machine_configuration_apply" "workers" {
  for_each = var.worker_ip_addresses
  client_configuration        = talos_machine_secrets.secret.client_configuration
  machine_configuration_input = data.talos_machine_configuration.workers.machine_configuration
  node                        = each.key
  depends_on = [ talos_cluster_kubeconfig.control_plane ]
}