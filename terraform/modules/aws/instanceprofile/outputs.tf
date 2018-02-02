output "role_name" {
  value = "${aws_iam_role.role.name}"
}

output "policy_arn" {
  value = "${aws_iam_policy.policy.arn}"
}

output "instance_profile_id" {
  value = "${aws_iam_instance_profile.instanceprofile.id}"
}
