variable "name" {}

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
