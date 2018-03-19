output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "policy_arn" {
  value = "${aws_iam_policy.policy.arn}"
}

output "policy_id" {
  value = "${aws_iam_policy.policy.id}"
}

output "instanceprofile_arn" {
  value = "${aws_iam_instance_profile.instanceprofile.arn}"
}

output "instanceprofile_id" {
  value = "${aws_iam_instance_profile.instanceprofile.id}"
}
