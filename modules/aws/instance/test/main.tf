terraform {
  required_version = ">= 0.11.3"
}


provider "aws" {
  version = ">= 1.8"

  region = "eu-west-1"
}


provider "template" {
  version = ">= 1.0"
}


variable "key_name" {
  default = "aws"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc_availability_zones" {
  default = [ "eu-west-1a", "eu-west-1b" ]
}
variable "vpc_subnet_public_cidrs" {
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}
variable "vpc_subnet_app_cidrs" {
  default = [ "10.0.4.0/24", "10.0.5.0/24" ]
}
variable "vpc_subnet_data_cidrs" {
  default = [ "10.0.7.0/24", "10.0.8.0/24" ]
}
variable "instance_instance_type" {
  default = "t2.micro"
}


module "vpc" {
  source = "../../vpc"
  name = "unittest-instance"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_availability_zones = "${var.vpc_availability_zones}"
  vpc_subnet_public_cidrs = "${var.vpc_subnet_public_cidrs}"
  vpc_subnet_app_cidrs = "${var.vpc_subnet_app_cidrs}"
  vpc_subnet_data_cidrs = "${var.vpc_subnet_data_cidrs}"
}


module "securitygroup-all" {
  source = "../../securitygroup"
  name = "unittest-instance-all"
  vpc_id = "${module.vpc.vpc_id}"
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


data "aws_iam_policy_document" "policy" {
  statement {
    actions = [ "ec2:DescribeTags" ]

    # Note:
    # As of December 2017 it doesn't look to be possible to limit this to
    # return information for the calling instance only.
    resources = [ "*" ]
  }
}


module "instanceprofile" {
  source = "../../instanceprofile"
  name = "unittest-instance"
  policy = "${data.aws_iam_policy_document.policy.json}"
}


data "template_file" "user-data" {
  template = ""

  vars {
  }
}


module "single" {
  source = "../../instance"
  name = "unittest-instance-single"
  count = 1
  vpc_id = "${module.vpc.vpc_id}"
  instance_subnet_ids = "${module.vpc.sn_public_ids}"
  instance_internet_gateway_id = "${module.vpc.igw_id}"
  instance_instance_profile_id = "${module.instanceprofile.instanceprofile_id}"
  instance_ami_id = "${data.aws_ami.centos7.id}"
  instance_user_data = "${data.template_file.user-data.rendered}"
  instance_key_name = "${var.key_name}"
  instance_instance_type = "${var.instance_instance_type}"
  instance_associate_public_ip_address = true
  instance_root_block_device_volume_size = 8
  instance_security_group_ids = [
    "${module.securitygroup-all.sg_id}"
  ]
  sg_allow_cidrs_len = 0
  sg_allow_cidrs = []
}


module "multiple" {
  source = "../../instance"
  name = "unittest-instance-multiple"
  count = 2
  vpc_id = "${module.vpc.vpc_id}"
  instance_subnet_ids = "${module.vpc.sn_public_ids}"
  instance_internet_gateway_id = "${module.vpc.igw_id}"
  instance_instance_profile_id = "${module.instanceprofile.instanceprofile_id}"
  instance_ami_id = "${data.aws_ami.centos7.id}"
  instance_user_data = "${data.template_file.user-data.rendered}"
  instance_key_name = "${var.key_name}"
  instance_instance_type = "${var.instance_instance_type}"
  instance_associate_public_ip_address = true
  instance_root_block_device_volume_size = 8
  instance_security_group_ids = [
    "${module.securitygroup-all.sg_id}"
  ]
  sg_allow_cidrs_len = 0
  sg_allow_cidrs = []
}
