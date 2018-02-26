variable "name" {}

variable "vpc_id" {}

variable "security_group_allow_cidrs_len" {
  default = 0
}

variable "security_group_allow_cidrs" {
  type = "list"
  default = []
}

variable "security_group_allow_ids_len" {
  default = 0
}

variable "security_group_allow_ids" {
  type = "list"
  default = []
}
