resource "null_resource" "elk" {
  depends_on = ["digitalocean_droplet.elk"]

  connection {
    host        = "${digitalocean_droplet.elk.ipv4_address}"
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  # put elastic config file
  provisioner "file" {
    source      = "./configs/elastic/elasticsearch.yml"
    destination = "/etc/elasticsearch/elasticsearch.yml"
  }

  # put kibana config file
  provisioner "file" {
    source      = "./configs/kibana/kibana.yml"
    destination = "/etc/kibana/kibana.yml"
  }

  # put logstash config file
  provisioner "file" {
    source      = "./configs/logstash/logstash.yml"
    destination = "/etc/logstash/logstash.yml"
  }

  provisioner "file" {
    source      = "./configs/logstash/logstash.conf"
    destination = "/etc/logstash/conf.d/logstash.conf"
  }

  provisioner "file" {
    source      = "./configs/nginx/default"
    destination = "/etc/nginx/sites-available/default"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable elasticsearch.service",
      "sudo systemctl start elasticsearch.service",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable kibana.service",
      "sudo systemctl start kibana.service",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable logstash.service",
      "sudo systemctl start logstash.service",

      # temporart disable nginx 
      "sudo systemctl stop nginx",
    ]
  }
}
