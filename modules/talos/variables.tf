variable "control_plane_ip_adress" {
  type = string
}

variable "agent_ip_adresses" {
  type = set(string)
}