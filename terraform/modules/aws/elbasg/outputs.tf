output "elb_sg_id" {
  value = "${module.securitygroup-elb.sg_id}"
}

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "asglc_sg_id" {
  value = "${module.securitygroup-asglc.sg_id}"
}

output "asglc_id" {
  value = "${aws_launch_configuration.asglc.id}"
}

output "asg_id" {
  value = "${aws_autoscaling_group.asg.id}"
}
