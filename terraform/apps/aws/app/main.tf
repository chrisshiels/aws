module "vpc" {
  source = "../../../modules/aws/vpc"
  name = "${var.env}"
  cidr = "10.0.0.0/16"
  availabilityzones = "${var.availabilityzones}"
  publicsubnetcidrs = "${var.publicsubnetcidrs}"
  appsubnetcidrs = "${var.appsubnetcidrs}"
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
  source = "../../../modules/aws/instanceprofile"
  name = "${var.env}-instance"
  policy = "${data.aws_iam_policy_document.policy.json}"
}


data "template_file" "user-data" {
  template = "${file(format("%s/files/user-data.tpl", path.module))}"

  vars {
  }
}


module "bastion" {
  source = "../../../modules/aws/instance"
  name = "${var.env}-bastion"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_id = "${element(module.vpc.subnet_public_ids, 0)}"
  internet_gateway_id = "${module.vpc.internet_gateway_id}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${data.aws_ami.centos7.id}"
  user_data = "${data.template_file.user-data.rendered}"
  key_name = "${var.key_name}"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  root_block_device_volume_size = 8
}


module "elbasg" {
  source = "../../../modules/aws/elbasg"
  name = "${var.env}-app"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_public_ids = "${module.vpc.subnet_public_ids}"
  subnet_app_ids = "${module.vpc.subnet_app_ids}"
  nat_gateway_ids = "${module.vpc.nat_gateway_ids}"
  instance_profile_id = "${module.instanceprofile.instance_profile_id}"
  ami_id = "${data.aws_ami.centos7.id}"
  user_data = "${data.template_file.user-data.rendered}"
  key_name = "${var.key_name}"
  instance_type = "t2.micro"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  desired_capacity = "${var.desired_capacity}"
  bastion_security_group_id = "${module.bastion.security_group_id}"
}
