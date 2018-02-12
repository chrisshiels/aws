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
