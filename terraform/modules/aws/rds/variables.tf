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
