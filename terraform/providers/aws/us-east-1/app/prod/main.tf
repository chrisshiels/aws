provider "aws" {
  region = "us-east-1"
}


module "app" {
  source = "../../../../../apps/aws/app"
  env = "prod"
  availabilityzones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  key_name = "aws"
}
