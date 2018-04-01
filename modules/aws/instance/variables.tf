variable "name" {}

variable "count" {}

variable "vpc_id" {}

variable "instance_subnet_ids" {
  type = "list"
}

variable "instance_internet_gateway_id" {}

variable "instance_instance_profile_id" {}

variable "instance_ami_id" {}

variable "instance_user_data" {}

variable "instance_key_name" {}

variable "instance_instance_type" {}

variable "instance_associate_public_ip_address" {}

variable "instance_root_block_device_volume_size" {}

variable "instance_security_group_ids" {
  type = "list"
  default = []
}

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
