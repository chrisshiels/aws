provider "aws" {
  region = "eu-west-1"
}


module "app" {
  source = "../../../../../apps/aws/app"
  env = "dev"
  availabilityzones = [ "eu-west-1a", "eu-west-1b", "eu-west-1c" ]
  key_name = "aws"
}
