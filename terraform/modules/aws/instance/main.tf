resource "aws_security_group" "instance" {
  name = "${format("sg_%s", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-${var.name}"
  }
}


resource "aws_security_group_rule" "instance-egress-allall-to-all" {
  security_group_id = "${aws_security_group.instance.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "instance-egress-allall-to-all"
}


resource "aws_security_group_rule" "instance-ingress-tcp22-from-all" {
  security_group_id = "${aws_security_group.instance.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "instance-ingress-tcp22-from-all"
}


resource "aws_instance" "instance" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]
  subnet_id = "${var.subnet_public_id}"
  associate_public_ip_address = true
  key_name = "${var.key_name}"
  monitoring = false
  user_data = "${var.user_data}"
  iam_instance_profile = "${var.instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }

  tags {
    Name = "${var.name}"
    TerraformDependsOn = "${var.internet_gateway_id}"
  }

  volume_tags {
    Name = "${var.name}"
  }
}
