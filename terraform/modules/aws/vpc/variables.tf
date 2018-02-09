variable "name" {}

variable "cidr" {}

variable "availabilityzones" {
  type = "list"
}

variable "publicsubnetcidrs" {
  type = "list"
}

variable "appsubnetcidrs" {
  type = "list"
}
