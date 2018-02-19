variable "name" {}

variable "cidr" {}

variable "availability_zones" {
  type = "list"
}

variable "subnet_public_cidrs" {
  type = "list"
}

variable "subnet_app_cidrs" {
  type = "list"
}

variable "subnet_data_cidrs" {
  type = "list"
}
