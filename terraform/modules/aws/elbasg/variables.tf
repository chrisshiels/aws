variable "name" {}

variable "vpc_id" {}

variable "elb_internal" {}

variable "elb_subnet_ids" {
  type = "list"
}

variable "elb_loadbalancer_protocol" {}

variable "elb_loadbalancer_port" {}

variable "elb_server_protocol" {}

variable "elb_server_port" {}

variable "elb_health_check_target" {}

variable "elb_security_group_ids" {
  type = "list"
  default = []
}

variable "elb_sg_allow_cidrs_len" {
  default = 0
}

variable "elb_sg_allow_cidrs" {
  type = "list"
  default = []
}

variable "elb_sg_allow_ids_len" {
  default = 0
}

variable "elb_sg_allow_ids" {
  type = "list"
  default = []
}

variable "asglc_instance_profile_id" {}

variable "asglc_ami_id" {}

variable "asglc_user_data" {}

variable "asglc_key_name" {}

variable "asglc_instance_type" {}

variable "asglc_security_group_ids" {
  type = "list"
  default = []
}

variable "asglc_sg_allow_cidrs_len" {
  default = 0
}

variable "asglc_sg_allow_cidrs" {
  type = "list"
  default = []
}

variable "asglc_sg_allow_ids_len" {
  default = 0
}

variable "asglc_sg_allow_ids" {
  type = "list"
  default = []
}

variable "asg_subnet_ids" {
  type = "list"
}

variable "asg_nat_gateway_ids" {
  type = "list"
}

variable "asg_min_size" {}

variable "asg_max_size" {}

variable "asg_desired_capacity" {}
