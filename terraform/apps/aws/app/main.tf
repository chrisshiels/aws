module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "${var.env}"
}


module "ami" {
  source = "../../../modules/aws/ami"
}


module "instanceprofile" {
  source = "../../../modules/aws/instanceprofile"
  name = "${var.env}"
}


module "userdata" {
  source = "../../../modules/aws/userdata"
}


module "bastion" {
  source = "../../../modules/aws/instance"
  name = "${var.env}-bastion"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${module.vpc.subnet_public_id}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${module.vpc.subnet_public_id}"
  subnet_private_id = "${module.vpc.subnet_private_id}"
  nat_gateway_id = "${module.vpc.nat_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
  bastion_security_group_id = "${module.bastion.security_group_id}"
}
