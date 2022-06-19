output "teleport_public_ip" {
  value = {
    for server, ip in module.teleport : server => ip.server_public_ip
  }
}

output "teleport_dns" {
  value = {
    for server, ip in module.teleport : server => join(".", [
      replace(ip.server_public_ip, ".", "-"),
      ip.server_zone,
      "upcloud",
      "host",
    ])
  }
}

output "teleport_url" {
  value = {
    for server, ip in module.teleport : server => join("", [
      "https://",
      join(".", [
        replace(ip.server_public_ip, ".", "-"),
        ip.server_zone,
        "upcloud",
        "host",
      ]),
    ])
  }
}
