variable "aws_profile" {}

provider "aws" {
  profile = "${var.aws_profile}"

  // AWS region does not matter since we're only dealing with IAM but is
  // required for the provider.
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "concourse_user" {
  name = "${terraform.workspace}-concourse"
  path = "/cloud-platform/"
}

resource "aws_iam_access_key" "iam_access_key" {
  user = "${aws_iam_user.concourse_user.name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "iam:GetUser",
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:UpdateUser",
      "iam:ListAccessKeys",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:PutUserPolicy",
      "iam:GetUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:ListGroupsForUser",
      "iam:PutUserPermissionsBoundary",
      "iam:DeleteUserPermissionsBoundary",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/system/*",
    ]
  }

  statement {
    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "rds:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticache:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "dynamodb:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:DescribeScalingPolicies",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*-autoscaler",
    ]
  }

  statement {
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroupReferences",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeStaleSecurityGroups",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "route53:CreateHostedZone",
    ]

    resources = [
       "*",
    ]
  }

  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
       "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:GetHostedZone",
      "route53:ListTagsForResource",
      "route53:ChangeTagsForResource",
      "route53:DeleteHostedZone",
    ]

    resources = [
       "arn:aws:route53:::hostedzone/*",
    ]
  }
}
  
resource "aws_iam_policy" "policy" {
  name        = "${terraform.workspace}-concourse-user-policy"
  path        = "/cloud-platform/"
  policy      = "${data.aws_iam_policy_document.policy.json}"
  description = "Policy for ${terraform.workspace}-concourse"
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "attached-policy"
  users      = ["${aws_iam_user.concourse_user.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

output "id" {
  value = "${aws_iam_access_key.iam_access_key.id}"
}

output "secret" {
  value = "${aws_iam_access_key.iam_access_key.secret}"
}
