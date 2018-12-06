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
      "sudo sed -i 's/:elasticsearch_port/${lookup(var.ports, "elasticsearch")}/g' /etc/elasticsearch/elasticsearch.yml",
      "sudo sed -i 's/:kibana_port/${lookup(var.ports, "kibana")}/g' /etc/kibana/kibana.yml",
      "sudo sed -i 's/:elasticsearch_port/${lookup(var.ports, "elasticsearch")}/g' /etc/kibana/kibana.yml",
      "sudo sed -i 's/:logstash_beat_port/${lookup(var.ports, "logstash_beat_input")}/g' /etc/logstash/conf.d/logstash.conf",
      "sudo sed -i 's/:logstash_http_port/${lookup(var.ports, "logstash_http_input")}/g' /etc/logstash/conf.d/logstash.conf",
      "sudo sed -i 's/:elasticsearch_port/${lookup(var.ports, "elasticsearch")}/g' /etc/logstash/conf.d/logstash.conf",

      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable elasticsearch.service",
      "sudo systemctl start elasticsearch.service",
      "sudo systemctl restart elasticsearch.service",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable kibana.service",
      "sudo systemctl start kibana.service",
      "sudo systemctl restart kibana.service",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable logstash.service",
      "sudo systemctl start logstash.service",
      "sudo systemctl restart logstash.service",

      # temporary disable nginx 
      "sudo systemctl stop nginx",
    ]
  }
}
