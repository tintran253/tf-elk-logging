resource "digitalocean_droplet" "elk" {
  image              = "ubuntu-18-10-x64"
  name               = "elk"
  region             = "sgp1"
  size               = "4gb"
  private_networking = true
  backups            = true
  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",

      # install java 8
      "sudo add-apt-repository -y ppa:webupd8team/java",

      "sudo apt-get update",
      "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections",
      "echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
      "sudo apt-get -y install oracle-java8-installer",
      "export JAVA_HOME=/usr/lib/jvm/java-8-oracle",
      "sudo apt-get update",
      "echo $JAVA_HOME",

      # install elastic
      "wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.1.deb",

      "wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.1.deb.sha512",
      "shasum -a 512 -c elasticsearch-6.5.1.deb.sha512",
      "sudo dpkg -i elasticsearch-6.5.1.deb",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable elasticsearch.service",
      "sudo systemctl start elasticsearch.service",

      # install kibana
      "wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.1-amd64.deb",

      "shasum -a 512 kibana-6.5.1-amd64.deb",
      "sudo dpkg -i kibana-6.5.1-amd64.deb",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable kibana.service",
      "sudo systemctl start kibana.service",

      # install logstash
      "wget --no-check-certificate https://artifacts.elastic.co/downloads/logstash/logstash-6.5.1.deb",
      "sudo dpkg -i logstash-6.5.1.deb",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable logstash.service",
      "sudo systemctl start logstash.service",

      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "sudo wget -d --header='PRIVATE-TOKEN: zyzM96gpQVEV-sxi-sLX' https://gitlab.com/api/v4/projects/9724480/repository/files/res%2Fnginx%2Fkibana/raw?ref=feature/elk -O /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]
  }
}

output "ip" {
  value = "${digitalocean_droplet.elk.ipv4_address}"
}
