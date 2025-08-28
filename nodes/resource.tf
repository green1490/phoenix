resource "random_string" "k3s_token" {
  length  = 64
  special = false
  upper   = true
}