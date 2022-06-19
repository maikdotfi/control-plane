resource "upcloud_server" "this" {
  hostname = "${var.project}-${var.environment}-${var.server.name}"
  zone     = var.server.region
  plan     = var.server.plan
  metadata = true

  template {
    storage = var.server.image
    size    = var.server.disk_size
  }

  network_interface {
    type = "public"
  }

  user_data = templatefile("${path.module}/user_data.tmpl", {
                  join_token  = var.teleport_join_token
                  auth_server = var.teleport_auth_server
                  environment = var.environment
                  project     = var.project
                  node_name   = "${var.project}-${var.environment}-${var.server.name}"
                }
              )

  login {
    user = "terraform"

    keys = [
      file("~/.ssh/id_rsa.pub")
    ]
  }
}
