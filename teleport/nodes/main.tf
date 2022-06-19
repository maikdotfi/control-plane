terraform {
  required_providers {
    upcloud = {
      source = "UpCloudLtd/upcloud"
    }
  }
}

provider "upcloud" {}

locals {
  servers = {
    lab-server-0 = {
      image     = "Ubuntu Server 20.04 LTS (Focal Fossa)"
      disk_size = 25
      region    = "fi-hel1"
      plan      = "1xCPU-1GB"
    }
  }
}

module "compute" {
  for_each = local.servers
  source   = "../modules/compute"

  project     = var.project
  environment = var.environment

  teleport_auth_server = var.teleport_auth_server
  teleport_join_token  = var.teleport_join_token

  server = merge(
    {
      name = each.key
    },
    each.value
  )
}

