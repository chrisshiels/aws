terraform {
  required_version = "= 0.11.3"
}


provider "aws" {
  version = "1.8"

  region = "us-east-1"
}


provider "template" {
  version = "1.0"
}


module "app" {
  source = "../../../../../apps/aws/app"
  env = "prod"
  availabilityzones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  publicsubnetcidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  appsubnetcidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
  datasubnetcidrs = [ "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24" ]
  key_name = "aws"
  min_size = 5
  max_size = 5
  desired_capacity = 5
}
