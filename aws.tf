provider "aws" {
  region = "eu-west-1"
}


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "vpc-dev"
  }
}


resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "sn-dev-public"
  }
}


resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags {
    Name = "sn-dev-private"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-dev"
  }
}


resource "aws_eip" "nat" {
  vpc = true
  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"

  tags {
    Name = "nat-dev"
  }

  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-dev-public"
  }
}


resource "aws_route" "public-default" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}


resource "aws_route_table_association" "public-public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "rtb-dev-private"
  }
}


resource "aws_route" "private-default" {
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


resource "aws_route_table_association" "private-private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
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


data "aws_iam_policy_document" "instance" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}


resource "aws_iam_role" "instance" {
  name = "role-dev-instance"
  assume_role_policy = "${data.aws_iam_policy_document.instance.json}"
}


data "aws_iam_policy_document" "describetags" {
  statement {
    actions = [ "ec2:DescribeTags" ]

    # Note:
    # As of December 2017 it doesn't look to be possible to limit this to
    # return information for the calling instance only.
    resources = [ "*" ]
  }
}


resource "aws_iam_policy" "describetags" {
  name = "policy-dev-describetags"
  policy = "${data.aws_iam_policy_document.describetags.json}"
}


resource "aws_iam_role_policy_attachment" "describetags" {
  role = "${aws_iam_role.instance.name}"
  policy_arn = "${aws_iam_policy.describetags.arn}"
}


resource "aws_iam_instance_profile" "instance" {
  name = "instanceprofile-dev-instance"
  role = "${aws_iam_role.instance.name}"
}


data "template_file" "user-data" {
  template = "${file("user-data.tpl")}"

  vars {
  }
}


resource "aws_security_group" "public" {
  name = "sg_dev_public"
  description = "public"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg-dev-public"
  }
}


resource "aws_security_group_rule" "public-egress-allall-to-all" {
  security_group_id = "${aws_security_group.public.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "public-egress-allall-to-all"
}


resource "aws_security_group_rule" "public-ingress-tcpall-from-all" {
  security_group_id = "${aws_security_group.public.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 0
  to_port = 65535
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "public-ingress-tcpall-from-all"
}


resource "aws_instance" "public" {
  ami = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.public.id}" ]
  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  key_name = "terraformaws"
  monitoring = false
  user_data = "${data.template_file.user-data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }

  tags {
    Name = "dev-public"
  }

  volume_tags {
    Name = "dev-public"
  }

  depends_on = [ "aws_internet_gateway.igw" ]
}


resource "aws_security_group" "private" {
  name = "sg_dev_private"
  description = "private"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg-dev-private"
  }
}


resource "aws_security_group_rule" "private-egress-allall-to-all" {
  security_group_id = "${aws_security_group.private.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "private-egress-allall-to-all"
}


resource "aws_security_group_rule" "private-ingress-tcpall-from-public" {
  security_group_id = "${aws_security_group.private.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 0
  to_port = 65535
  source_security_group_id = "${aws_security_group.public.id}"
  description = "private-ingress-tcpall-from-public"
}


resource "aws_instance" "private" {
  ami = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.private.id}" ]
  subnet_id = "${aws_subnet.private.id}"
  associate_public_ip_address = false
  key_name = "terraformaws"
  monitoring = false
  user_data = "${data.template_file.user-data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }

  tags {
    Name = "dev-private"
  }

  volume_tags {
    Name = "dev-private"
  }

  depends_on = [ "aws_nat_gateway.nat" ]
}


resource "aws_security_group" "elb" {
  name = "sg_dev_elb"
  description = "elb"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg-dev-elb"
  }
}


resource "aws_security_group_rule" "elb-egress-allall-to-all" {
  security_group_id = "${aws_security_group.elb.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "elb-egress-allall-to-all"
}


resource "aws_security_group_rule" "elb-ingress-tcp80-from-all" {
  security_group_id = "${aws_security_group.elb.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "elb-ingress-tcp80-from-all"
}


resource "aws_elb" "elb" {
  name = "elb-dev-app"
  internal = false
  subnets = [ "${aws_subnet.public.id}" ]
  security_groups = [ "${aws_security_group.elb.id}" ]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    lb_protocol = "http"
    lb_port = 80
    instance_protocol = "http"
    instance_port = 80
  }

  health_check {
    target = "HTTP:80/"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 10
  }

  tags {
    Name = "elb-dev-app"
  }
}


resource "aws_security_group" "app" {
  name = "sg_dev_app"
  description = "app"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg-dev-app"
  }
}


resource "aws_security_group_rule" "app-egress-allall-to-all" {
  security_group_id = "${aws_security_group.app.id}"
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "app-egress-allall-to-all"
}


resource "aws_security_group_rule" "app-ingress-tcp22-from-public" {
  security_group_id = "${aws_security_group.app.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  source_security_group_id = "${aws_security_group.public.id}"
  description = "app-ingress-tcp22-from-public"
}


resource "aws_security_group_rule" "app-ingress-tcp80-from-public" {
  security_group_id = "${aws_security_group.app.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  source_security_group_id = "${aws_security_group.public.id}"
  description = "app-ingress-tcp80-from-public"
}


resource "aws_security_group_rule" "app-ingress-tcp80-from-elb" {
  security_group_id = "${aws_security_group.app.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  source_security_group_id = "${aws_security_group.elb.id}"
  description = "app-ingress-tcp80-from-elb"
}


resource "aws_launch_configuration" "app" {
  name = "asglc-dev-app"
  image_id = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.app.id}" ]
  associate_public_ip_address = false
  key_name = "terraformaws"
  enable_monitoring = false
  user_data = "${data.template_file.user-data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}


resource "aws_autoscaling_group" "app" {
  name = "asg-dev-app"
  launch_configuration = "${aws_launch_configuration.app.name}"
  vpc_zone_identifier = [ "${aws_subnet.private.id}" ]
  load_balancers = [ "${aws_elb.elb.id}" ]
  min_size = 2
  max_size = 2
  desired_capacity = 2
  default_cooldown = 30
  health_check_grace_period = 60
  health_check_type = "EC2"
  force_delete = false

  tag {
    key = "Name"
    value = "dev-app"
    propagate_at_launch = true
  }

  depends_on = [ "aws_nat_gateway.nat" ]
}
