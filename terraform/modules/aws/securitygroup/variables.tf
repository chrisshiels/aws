variable "name" {}

variable "vpc_id" {}

variable "security_group_ports_tcp" {
  type = "list"
  default = []
}

variable "security_group_ports_udp" {
  type = "list"
  default = []
}

variable "security_group_cidrs" {
  type = "list"
  default = []
}

variable "security_group_ids" {
  type = "list"
  default = []
}
