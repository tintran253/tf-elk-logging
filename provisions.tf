resource "null_resource" "elk" {
  depends_on = ["digitalocean_droplet.elk"]
  connection {
    host        = "${digitalocean_droplet.elk.ipv4_address}"
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "./res/nginx/default"
    destination = "/etc/nginx/sites-available/default"
  }

  provisioner "file" {
    source      = "./res/logstash/logstash.conf"
    destination = "/etc/logstash/conf.d/logstash.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl restart nginx",
    ]
  }
}
