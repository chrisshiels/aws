data "aws_iam_policy_document" "assumerole" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}


resource "aws_iam_role" "role" {
  name = "role-${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.assumerole.json}"
}


resource "aws_iam_policy" "policy" {
  name = "policy-${var.name}"
  policy = "${var.policy}"
}


resource "aws_iam_role_policy_attachment" "policyattachment" {
  role = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}


resource "aws_iam_instance_profile" "instanceprofile" {
  name = "instanceprofile-${var.name}"
  role = "${aws_iam_role.role.name}"
}
