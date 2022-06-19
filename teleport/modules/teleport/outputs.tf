output "server_public_ip" {
  value = upcloud_server.this.network_interface[0].ip_address
}

output "server_zone" {
  value = upcloud_server.this.zone
}
