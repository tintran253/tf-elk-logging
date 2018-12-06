
output "ip" {
  value = "${digitalocean_droplet.elk.ipv4_address}"
}
output "kibana"{
  value = "${digitalocean_droplet.elk.ipv4_address}:${lookup(var.ports, "kibana")}"
}
output "elasticsearch"{
  value = "${digitalocean_droplet.elk.ipv4_address}:${lookup(var.ports, "elasticsearch")}"
}
output "filebeat"{
  value = "${digitalocean_droplet.elk.ipv4_address}:${lookup(var.ports, "logstash_beat_input")}"
}
output "httplog"{
  value = "${digitalocean_droplet.elk.ipv4_address}:${lookup(var.ports, "logstash_http_input")}"
}