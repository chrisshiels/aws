provider "aws" {
  region = "eu-west-1"
}


module "app" {
  source = "../../../../apps/aws/app"
}
