variable "env" {}

variable "key_name" {}

variable "vpc_availability_zones" {
  type = "list"
}

variable "vpc_public_subnet_cidrs" {
  type = "list"
}

variable "vpc_app_subnet_cidrs" {
  type = "list"
}

variable "vpc_data_subnet_cidrs" {
  type = "list"
}

variable "asg_instance_type" {}

variable "asg_min_size" {}

variable "asg_max_size" {}

variable "asg_desired_capacity" {}

variable "rds_multi_az" {}

variable "rds_instance_class" {}

variable "rds_allocated_storage" {}

variable "rds_backup_window" {}

variable "rds_backup_retention_period" {}

variable "rds_maintenance_window" {}
