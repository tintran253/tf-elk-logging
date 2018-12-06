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

      # install kibana
      "wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.1-amd64.deb",

      "shasum -a 512 kibana-6.5.1-amd64.deb",
      "sudo dpkg -i kibana-6.5.1-amd64.deb",

      # install logstash
      "wget --no-check-certificate https://artifacts.elastic.co/downloads/logstash/logstash-6.5.1.deb",

      "sudo dpkg -i logstash-6.5.1.deb",

      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
    ]
  }
}
