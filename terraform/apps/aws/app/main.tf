module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "${var.env}"
  cidr = "10.0.0.0/16"
  availabilityzones = "${var.availabilityzones}"
  publicsubnetcidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  privatesubnetcidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}


data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name = "name"
    values = [ "CentOS Linux 7 x86_64 HVM EBS*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ "679593333241" ]
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
  ami_id = "${data.aws_ami.centos7.id}"
  user_data = "${module.userdata.user_data}"
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_ids = "${module.vpc.subnet_public_ids}"
  subnet_private_ids = "${module.vpc.subnet_private_ids}"
  nat_gateway_id = "${module.vpc.nat_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${data.aws_ami.centos7.id}"
  user_data = "${module.userdata.user_data}"
  bastion_security_group_id = "${module.bastion.security_group_id}"
}
