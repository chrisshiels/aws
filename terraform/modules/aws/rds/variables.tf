variable "name" {}

variable "vpc_id" {}

variable "dbsg_subnet_ids" {
  type = "list"
}

variable "db_engine" {}

variable "db_engine_version" {}

variable "db_license_model" {}

variable "db_port" {}

variable "db_multi_az" {}

variable "db_instance_class" {}

variable "db_allocated_storage" {}

variable "db_username" {}

variable "db_password" {}

variable "db_schema_name" {}

variable "db_backup_window" {}

variable "db_backup_retention_period" {}

variable "db_maintenance_window" {}

variable "db_auto_minor_version_upgrade" {}

variable "db_apply_immediately" {}

variable "db_skip_final_snapshot" {}

variable "db_security_group_ids" {
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
