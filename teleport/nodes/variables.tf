variable "environment" {
  default = "env"
}

variable "project" {
  default = "seaweed"
}

variable "teleport_auth_server" {
  type        = string
  description = "hostname+port of the Teleport auth server e.g. tele.example.com:443"
}

variable "teleport_join_token" {
  type        = string
  description = "Token of type node to join the node into Teleport cluster"
}
