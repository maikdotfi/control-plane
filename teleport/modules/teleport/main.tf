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

  user_data = file("${path.module}/user_data.tmpl")

  login {
    user = "terraform"

    keys = [
      file("~/.ssh/id_rsa.pub")
    ]
  }
}
