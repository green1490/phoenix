data "talos_machine_configuration" "control_plane" {
  cluster_name     = "example-cluster"
  machine_type     = "controlplane"
  cluster_endpoint = "https://${var.control_plane_ip_adress}"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}