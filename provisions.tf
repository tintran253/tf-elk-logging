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
    content     = "${data.template_file.elastic_yml.rendered}"
    destination = "/etc/elasticsearch/elasticsearch.yml"
  }

  # put kibana config file
  provisioner "file" {
    content     = "${data.template_file.kibana_yml.rendered}"
    destination = "/etc/kibana/kibana.yml"
  }

  # put logstash config file
  provisioner "file" {
    content     = "${data.template_file.logstash_yml.rendered}"
    destination = "/etc/logstash/logstash.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.logstash_conf.rendered}"
    destination = "/etc/logstash/conf.d/logstash.conf"
  }

  provisioner "file" {
    content     = "${data.template_file.nginx.rendered}"
    destination = "/etc/nginx/sites-available/default"
  }

  provisioner "remote-exec" {
    inline = [
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
