
output "ip" {
  value = "${digitalocean_droplet.elk.ipv4_address}"
}