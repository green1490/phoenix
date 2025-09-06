variable "control_plane_ip_address" {
  type = string
}

variable "worker_ip_addresses" {
  type = set(string)
}