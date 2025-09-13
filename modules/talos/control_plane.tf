data "talos_machine_configuration" "control_plane" {
  cluster_name     = "infra"
  machine_type     = "controlplane"
  cluster_endpoint = "https://${var.control_plane_ip_address}:6443"
  machine_secrets  = talos_machine_secrets.secret.machine_secrets  
}

data "talos_client_configuration" "control_plane" {
  cluster_name = "infra"
  client_configuration = talos_machine_secrets.secret.client_configuration
  nodes = [ var.control_plane_ip_address ]
}

resource "talos_machine_configuration_apply" "control_plane" {
  client_configuration        = talos_machine_secrets.secret.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node = var.control_plane_ip_address
}

resource "talos_machine_bootstrap" "control_plane" {
  depends_on = [
    talos_machine_configuration_apply.control_plane,
  ]
  node                 = var.control_plane_ip_address
  client_configuration = talos_machine_secrets.secret.client_configuration
}

resource "talos_cluster_kubeconfig" "control_plane" {
  depends_on = [
    talos_machine_bootstrap.control_plane,
  ]
  client_configuration = talos_machine_secrets.secret.client_configuration
  node                 = var.control_plane_ip_address
}