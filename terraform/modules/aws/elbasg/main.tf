resource "aws_security_group" "elb" {
  name = "${format("sg_%s_elb", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}-elb"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-${var.name}-elb"
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
  name = "elb-${var.name}"
  internal = false
  subnets = [ "${var.subnet_public_ids}" ]
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
    Name = "elb-${var.name}"
  }
}


resource "aws_security_group" "app" {
  name = "${format("sg_%s", replace(var.name, "-", "_"))}"
  description = "sg-${var.name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "sg-${var.name}"
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


resource "aws_security_group_rule" "app-ingress-tcp22-from-bastion" {
  security_group_id = "${aws_security_group.app.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  source_security_group_id = "${var.bastion_security_group_id}"
  description = "app-ingress-tcp22-from-bastion"
}


resource "aws_security_group_rule" "app-ingress-tcp80-from-bastion" {
  security_group_id = "${aws_security_group.app.id}"
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  source_security_group_id = "${var.bastion_security_group_id}"
  description = "app-ingress-tcp80-from-bastion"
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
  name = "asglc-${var.name}"
  image_id = "${var.ami_id}"
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.app.id}" ]
  associate_public_ip_address = false
  key_name = "${var.key_name}"
  enable_monitoring = false
  user_data = "${var.user_data}"
  iam_instance_profile = "${var.instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}


resource "aws_autoscaling_group" "app" {
  name = "asg-${var.name}"
  launch_configuration = "${aws_launch_configuration.app.name}"
  vpc_zone_identifier = [ "${var.subnet_private_ids}" ]
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
    value = "asg-${var.name}"
    propagate_at_launch = true
  }

  tag {
    key = "TerraformDependsOn"
    value = "${join(",", var.nat_gateway_ids)}"
    propagate_at_launch = true
  }
}
