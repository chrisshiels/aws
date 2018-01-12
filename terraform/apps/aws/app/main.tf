module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "dev"
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
  name = "dev-bastion"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${module.vpc.subnet_public_id}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "dev-app"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${module.vpc.subnet_public_id}"
  subnet_private_id = "${module.vpc.subnet_private_id}"
  nat_gateway_id = "${module.vpc.nat_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
  bastion_security_group_id = "${module.bastion.bastion_security_group_id}"
}
