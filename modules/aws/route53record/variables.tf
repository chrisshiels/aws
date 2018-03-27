variable "name" {}

variable "r53_zone_id" {}

variable "r53_records_len" {
  default = 0
}

variable "r53_records" {
  type = "list"
  default = []
}
