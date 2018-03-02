output "security_group_elb_id" {
  value = "${module.securitygroup-elb.security_group_id}"
}

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "security_group_asglc_id" {
  value = "${module.securitygroup-asglc.security_group_id}"
}

output "launch_configuration_asglc_id" {
  value = "${aws_launch_configuration.asglc.id}"
}

output "autoscaling_group_asg_id" {
  value = "${aws_autoscaling_group.asg.id}"
}
