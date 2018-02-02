variable "name" {}

variable "vpc_id" {}

variable "subnet_public_ids" {
  type = "list"
}

variable "subnet_private_ids" {
  type = "list"
}

variable "nat_gateway_ids" {
  type = "list"
}

variable "instance_profile_id" {}

variable "ami_id" {}

variable "user_data" {}

variable "key_name" {}

variable "instance_type" {}

variable "bastion_security_group_id" {}
