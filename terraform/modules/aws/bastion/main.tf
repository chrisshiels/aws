resource "aws_security_group" "bastion" {
  name = "sg_dev_bastion"
  description = "bastion"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-dev-bastion"
  }
}


resource "aws_security_group_rule" "bastion-egress-allall-to-all" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "bastion-egress-allall-to-all"
}


resource "aws_security_group_rule" "bastion-ingress-tcp22-from-all" {
  security_group_id = "${aws_security_group.bastion.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "bastion-ingress-tcp22-from-all"
}


resource "aws_instance" "bastion" {
  ami = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.bastion.id}" ]
  subnet_id = "${var.subnet_public_id}"
  associate_public_ip_address = true
  key_name = "aws"
  monitoring = false
  user_data = "${data.template_file.user-data.rendered}"
  iam_instance_profile = "${var.instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }

  tags {
    Name = "dev-bastion"
    TerraformDependsOn = "${var.internet_gateway_id}"
  }

  volume_tags {
    Name = "dev-bastion"
  }
}
