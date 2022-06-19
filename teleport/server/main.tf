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
    my-server = {
      image     = "Ubuntu Server 20.04 LTS (Focal Fossa)"
      disk_size = 25
      region    = "fi-hel1"
      plan      = "1xCPU-1GB"
    }
  }
}

module "teleport" {
  for_each = local.servers
  source   = "../modules/teleport"

  project     = var.project
  environment = var.environment

  server = merge(
    {
      name = each.key
    },
    each.value
  )
}

