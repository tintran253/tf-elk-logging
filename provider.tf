variable "do_token" {
  default = "190a4c9a2d2f4a4dd390b7456fde7df647485a03f567e52316a7c78972f3d32e"
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_fingerprint" {
  default = "65:18:b9:f7:01:53:5e:90:e7:d5:58:01:75:dd:82:19"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

