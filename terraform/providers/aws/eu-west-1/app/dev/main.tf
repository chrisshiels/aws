terraform {
  required_version = "= 0.11.3"
}


provider "aws" {
  version = "1.8"

  region = "eu-west-1"
}


provider "template" {
  version = "1.0"
}


module "app" {
  source = "../../../../../stacks/aws/app"
  env = "dev"
  availabilityzones = [ "eu-west-1a", "eu-west-1b" ]
  publicsubnetcidrs = [ "10.0.1.0/24", "10.0.2.0/24" ]
  appsubnetcidrs = [ "10.0.4.0/24", "10.0.5.0/24" ]
  datasubnetcidrs = [ "10.0.7.0/24", "10.0.8.0/24" ]
  key_name = "aws"
  min_size = 2
  max_size = 2
  desired_capacity = 2
}
