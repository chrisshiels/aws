module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "${var.env}"
  cidr = "10.0.0.0/16"
  availabilityzones = [ "eu-west-1a",  "eu-west-1b", "eu-west-1c" ]
  publicsubnetcidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  privatesubnetcidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
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
  subnet_public_id = "${element(module.vpc.subnet_public_ids, 0)}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${element(module.vpc.subnet_public_ids, 0)}"
  subnet_private_id = "${element(module.vpc.subnet_private_ids, 0)}"
  nat_gateway_id = "${module.vpc.nat_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${module.ami.ami_id}"
  user_data = "${module.userdata.user_data}"
  bastion_security_group_id = "${module.bastion.security_group_id}"
}
