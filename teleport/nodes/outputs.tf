output "nodes_public_ip" {
  value = {
    for server, ip in module.compute : server => ip.server_public_ip
  }
}

output "nodes_dns" {
  value = {
    for server, ip in module.compute : server => join(".", [
      replace(ip.server_public_ip, ".", "-"),
      ip.server_zone,
      "upcloud",
      "host",
    ])
  }
}
