variable "name" {}

variable "vpc_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "engine" {}

variable "engine_version" {}

variable "license_model" {}

variable "port" {}

variable "multi_az" {}

variable "instance_class" {}

variable "allocated_storage" {}

variable "username" {}

variable "password" {}

variable "schema_name" {}

variable "backup_window" {}

variable "backup_retention_period" {}

variable "maintenance_window" {}

variable "auto_minor_version_upgrade" {}

variable "apply_immediately" {}

variable "skip_final_snapshot" {}

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
