variable "env" {}

variable "availabilityzones" {
  type = "list"
}

variable "publicsubnetcidrs" {
  type = "list"
}

variable "privatesubnetcidrs" {
  type = "list"
}

variable "key_name" {}

variable "min_size" {}

variable "max_size" {}

variable "desired_capacity" {}
