provider "aws" {
  region = "us-east-1"
}


module "app" {
  source = "../../../../../apps/aws/app"
  env = "prod"
  availabilityzones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  key_name = "aws"
  min_size = 5
  max_size = 5
  desired_capacity = 5
}
