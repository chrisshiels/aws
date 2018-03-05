variable "env" {}

variable "key_name" {}

variable "vpc_cidr" {}

variable "vpc_availability_zones" {
  type = "list"
}

variable "vpc_subnet_public_cidrs" {
  type = "list"
}

variable "vpc_subnet_app_cidrs" {
  type = "list"
}

variable "vpc_subnet_data_cidrs" {
  type = "list"
}

variable "bastion_instance_type" {}

variable "bastion_ssh_cidrs" {
  type = "list"
}

variable "elb_http_cidrs" {
  type = "list"
}

variable "asglc_instance_type" {}

variable "asg_min_size" {}

variable "asg_max_size" {}

variable "asg_desired_capacity" {}

variable "db_multi_az" {}

variable "db_instance_class" {}

variable "db_allocated_storage" {}

variable "db_username" {}

variable "db_password" {}

variable "db_backup_window" {}

variable "db_backup_retention_period" {}

variable "db_maintenance_window" {}
