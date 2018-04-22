variable "name" {}

variable "vpc_id" {}

variable "sg_allow_cidrs_len" {
  default = 0
}

variable "sg_allow_cidrs" {
  type = "list"
  default = []
}

variable "sg_allow_ids_len" {
  default = 0
}

variable "sg_allow_ids" {
  type = "list"
  default = []
}

variable "tags" {
  type = "map"
  default = {}
}
