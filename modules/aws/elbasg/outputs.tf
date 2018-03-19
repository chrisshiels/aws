output "elb_sg_id" {
  value = "${module.securitygroup-elb.sg_id}"
}

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "elb_arn" {
  value = "${aws_elb.elb.arn}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "elb_zone_id" {
  value = "${aws_elb.elb.zone_id}"
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

output "asg_arn" {
  value = "${aws_autoscaling_group.asg.arn}"
}
