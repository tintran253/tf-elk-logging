variable "do_token" {}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_fingerprint" {}

variable "elk_cfg" {
  default = "./res/"
}

variable "kibana_nginx" {
  default = "./res/nginx/kibana"
}
