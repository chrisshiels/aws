variable "env" {}

variable "availabilityzones" {
  type = "list"
}

variable "publicsubnetcidrs" {
  type = "list"
}

variable "appsubnetcidrs" {
  type = "list"
}

variable "datasubnetcidrs" {
  type = "list"
}

variable "key_name" {}

variable "min_size" {}

variable "max_size" {}

variable "desired_capacity" {}

variable "rds_multi_az" {}

variable "rds_instance_class" {}

variable "rds_allocated_storage" {}

variable "rds_backup_window" {}

variable "rds_backup_retention_period" {}

variable "rds_maintenance_window" {}
