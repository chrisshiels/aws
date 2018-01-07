data "aws_iam_policy_document" "assumerole" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}


resource "aws_iam_role" "instance" {
  name = "role-dev-instance"
  assume_role_policy = "${data.aws_iam_policy_document.assumerole.json}"
}


data "aws_iam_policy_document" "describetags" {
  statement {
    actions = [ "ec2:DescribeTags" ]

    # Note:
    # As of December 2017 it doesn't look to be possible to limit this to
    # return information for the calling instance only.
    resources = [ "*" ]
  }
}


resource "aws_iam_policy" "describetags" {
  name = "policy-dev-describetags"
  policy = "${data.aws_iam_policy_document.describetags.json}"
}


resource "aws_iam_role_policy_attachment" "describetags" {
  role = "${aws_iam_role.instance.name}"
  policy_arn = "${aws_iam_policy.describetags.arn}"
}


resource "aws_iam_instance_profile" "instance" {
  name = "instanceprofile-dev-instance"
  role = "${aws_iam_role.instance.name}"
}
