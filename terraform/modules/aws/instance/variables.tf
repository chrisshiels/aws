variable "name" {}

variable "vpc_id" {}

variable "subnet_public_id" {}

variable "internet_gateway_id" {}

variable "instance_profile_id" {}

variable "ami_id" {}

variable "user_data" {}

variable "key_name" {}

variable "instance_type" {}

variable "associate_public_ip_address" {}

variable "root_block_device_volume_size" {}

variable "security_group_ids" {
  type = "list"
  default = []
}

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
