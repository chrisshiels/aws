module "vpc" {
  source = "../../../modules/aws/vpc"
}


module "ami" {
  source = "../../../modules/aws/ami"
}


module "instanceprofile" {
  source = "../../../modules/aws/instanceprofile"
}


module "userdata" {
  source = "../../../modules/aws/userdata"
}


module "bastion" {
  source = "../../../modules/aws/bastion"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
}
