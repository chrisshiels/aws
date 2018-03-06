output "elb_sg_id" {
  value = "${module.securitygroup-elb.security_group_id}"
}

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "asglc_sg_id" {
  value = "${module.securitygroup-asglc.security_group_id}"
}

output "asglc_id" {
  value = "${aws_launch_configuration.asglc.id}"
}

output "asg_id" {
  value = "${aws_autoscaling_group.asg.id}"
}
