output "security_group_elb_id" {
  value = "${module.securitygroup-elb.security_group_id}"
}

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "security_group_app_id" {
  value = "${module.securitygroup-app.security_group_id}"
}

output "launch_configuration_app_id" {
  value = "${aws_launch_configuration.app.id}"
}

output "autoscaling_group_app_id" {
  value = "${aws_autoscaling_group.app.id}"
}
