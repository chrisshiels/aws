variable "name" {}

variable "vpc_id" {}

variable "subnet_public_ids" {
  type = "list"
}

variable "subnet_app_ids" {
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

variable "min_size" {}

variable "max_size" {}

variable "desired_capacity" {}

variable "bastion_security_group_id" {}

variable "elb_security_group_ids" {
  type = "list"
  default = []
}

variable "elb_security_group_allow_cidrs_len" {
  default = 0
}

variable "elb_security_group_allow_cidrs" {
  type = "list"
  default = []
}

variable "elb_security_group_allow_ids_len" {
  default = 0
}

variable "elb_security_group_allow_ids" {
  type = "list"
  default = []
}

variable "asg_security_group_ids" {
  type = "list"
  default = []
}

variable "asg_security_group_allow_cidrs_len" {
  default = 0
}

variable "asg_security_group_allow_cidrs" {
  type = "list"
  default = []
}

variable "asg_security_group_allow_ids_len" {
  default = 0
}

variable "asg_security_group_allow_ids" {
  type = "list"
  default = []
}
