module "securitygroup-elb" {
  source = "../../../modules/aws/securitygroup"
  name = "${var.name}-elb"
  vpc_id = "${var.vpc_id}"
  sg_allow_cidrs_len = "${var.elb_sg_allow_cidrs_len}"
  sg_allow_cidrs = [ "${var.elb_sg_allow_cidrs}" ]
  sg_allow_ids_len = "${var.elb_sg_allow_ids_len}"
  sg_allow_ids = [ "${var.elb_sg_allow_ids}" ]
}


resource "aws_elb" "elb" {
  name = "elb-${var.name}"
  internal = "${var.elb_internal}"
  subnets = [ "${var.elb_subnet_ids}" ]
  security_groups = [
    "${var.elb_security_group_ids}",
    "${module.securitygroup-elb.sg_id}"
  ]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  listener {
    lb_protocol = "${var.elb_loadbalancer_protocol}"
    lb_port = "${var.elb_loadbalancer_port}"
    instance_protocol = "${var.elb_server_protocol}"
    instance_port = "${var.elb_server_port}"
  }

  health_check {
    target = "${var.elb_health_check_target}"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 10
  }

  tags {
    Name = "elb-${var.name}"
  }
}


module "securitygroup-asglc" {
  source = "../../../modules/aws/securitygroup"
  name = "${var.name}-asglc"
  vpc_id = "${var.vpc_id}"
  sg_allow_cidrs_len = "${var.asglc_sg_allow_cidrs_len}"
  sg_allow_cidrs = [ "${var.asglc_sg_allow_cidrs}" ]
  sg_allow_ids_len = "${var.asglc_sg_allow_ids_len + 1}"
  sg_allow_ids = [
    "${var.asglc_sg_allow_ids}",
    "tcp:${var.elb_server_port}:${module.securitygroup-elb.sg_id}"
  ]
}


resource "aws_launch_configuration" "asglc" {
  name = "asglc-${var.name}"
  image_id = "${var.asglc_ami_id}"
  instance_type = "${var.asglc_instance_type}"
  security_groups = [
    "${var.asglc_security_group_ids}",
    "${module.securitygroup-asglc.sg_id}"
  ]
  associate_public_ip_address = false
  key_name = "${var.asglc_key_name}"
  enable_monitoring = false
  user_data = "${var.asglc_user_data}"
  iam_instance_profile = "${var.asglc_instance_profile_id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name = "asg-${var.name}"
  launch_configuration = "${aws_launch_configuration.asglc.name}"
  vpc_zone_identifier = [ "${var.asg_subnet_ids}" ]
  load_balancers = [ "${aws_elb.elb.id}" ]
  min_size = "${var.asg_min_size}"
  max_size = "${var.asg_max_size}"
  desired_capacity = "${var.asg_desired_capacity}"
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
    value = "${join(",", var.asg_nat_gateway_ids)}"
    propagate_at_launch = true
  }
}
