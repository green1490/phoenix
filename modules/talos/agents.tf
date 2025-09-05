data "talos_client_configuration" "this" {
  cluster_name         = "infra"
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = var.agent_ip_adresses
}