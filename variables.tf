variable "do_token" {}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_fingerprint" {}

variable "ports" {
  type = "map"

  default = {
    "elasticsearch"       = 9200
    "kibana"              = 5601
    "logstash_beat_input" = 5044
    "logstash_http_input" = 3131
  }
}

data "template_file" "elastic_yml" {
  template = "${file("./configs/elastic/elasticsearch.yml")}"

  vars {
    elasticsearch_port = "${lookup(var.ports,"elasticsearch")}"
  }
}

data "template_file" "kibana_yml" {
  template = "${file("./configs/kibana/kibana.yml")}"

  vars {
    elasticsearch_port = "${lookup(var.ports,"elasticsearch")}"
    kibana_port        = "${lookup(var.ports,"kibana")}"
  }
}

data "template_file" "logstash_yml" {
  template = "${file("./configs/logstash/logstash.yml")}"
}

data "template_file" "logstash_conf" {
  template = "${file("./configs/logstash/logstash.conf")}"

  vars {
    elasticsearch_port = "${lookup(var.ports,"elasticsearch")}"
    logstash_beat_port = "${lookup(var.ports,"logstash_beat_input")}"
    logstash_http_port = "${lookup(var.ports,"logstash_http_input")}"
  }
}

data "template_file" "nginx" {
  template = "${file("./configs/nginx/default")}"

  vars {
    kibana_port = "${lookup(var.ports,"kibana")}"
  }
}
