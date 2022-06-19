
variable "project" {
  description = "Project which the resources belongs to"
  type        = string
}

variable "environment" {
  description = "Environment for the resources (e.g. prod/dev)"
  type        = string
}

variable "server" {
  description = "Server Configuration"
  type = object({
    name      = string
    image     = string
    disk_size = number
    region    = string
    plan      = string
  })
}

variable "teleport_auth_server" {
  type        = string
  description = "hostname+port of the Teleport auth server e.g. tele.example.com:443"
}

variable "teleport_join_token" {
  type        = string
  description = "Token of type node to join the node into Teleport cluster"
}
