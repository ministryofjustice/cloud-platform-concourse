data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {
    bucket = "moj-cp-k8s-investigation-concourse-terraform"
    region = "eu-west-1"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "moj-cp-k8s-investigation-platform-terraform"
    region = "eu-west-1"
    key    = "/env:/${terraform.workspace}/terraform.tfstate"
  }
}

/*
 * Create RDS database for concourse.
 *
 */

resource "aws_security_group" "concourse" {
  name        = "${terraform.workspace}-concourse-rds"
  description = "Allow all inbound traffic from the VPC"
  vpc_id      = "${data.terraform_remote_state.cluster.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.terraform_remote_state.cluster.internal_subnets}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${terraform.workspace}-concourse-rds"
  }
}

resource "aws_db_subnet_group" "concourse" {
  name        = "${terraform.workspace}-concourse"
  description = "Internal subnet groups"
  subnet_ids  = ["${data.terraform_remote_state.cluster.internal_subnets_ids}"]
}

resource "random_string" "db_password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "concourse" {
  depends_on             = ["aws_security_group.concourse"]
  identifier             = "${terraform.workspace}-concourse"
  allocated_storage      = "${var.rds_storage}"
  engine                 = "postgres"
  engine_version         = "${var.rds_postgresql_version}"
  instance_class         = "${var.rds_instance_class}"
  name                   = "concourse"
  username               = "concourse"
  password               = "${random_string.db_password.result}"
  vpc_security_group_ids = ["${aws_security_group.concourse.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.concourse.id}"
  skip_final_snapshot    = true
}

/*
 * Generate the `values.yaml` configuration for the concourse helm chart.
 *
 */

resource "tls_private_key" "host_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_private_key" "session_signing_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "random_string" "basic_auth_username" {
  length  = 16
  special = false
}

resource "random_string" "basic_auth_password" {
  length  = 32
  special = false
}

data "template_file" "values" {
  template = "${file("${path.module}/templates/values.yaml")}"

  vars {
    concourse_image_tag       = "${var.concourse_image_tag}"
    concourse_chart_version   = "${var.concourse_chart_version}"
    basic_auth_username       = "${random_string.basic_auth_username.result}"
    basic_auth_password       = "${random_string.basic_auth_password.result}"
    github_auth_client_id     = "${local.secrets["github_auth_client_id"]}"
    github_auth_client_secret = "${local.secrets["github_auth_client_secret"]}"
    concourse_hostname        = "concourse.apps.${data.terraform_remote_state.cluster.cluster_domain_name}"
    github_teams              = "${local.secrets["github_teams"]}"
    postgresql_user           = "${aws_db_instance.concourse.username}"
    postgresql_password       = "${aws_db_instance.concourse.password}"
    postgresql_host           = "${aws_db_instance.concourse.address}"
    postgresql_sslmode        = false
    host_key_priv             = "${indent(4, tls_private_key.host_key.private_key_pem)}"
    host_key_pub              = "${tls_private_key.host_key.public_key_openssh}"
    session_signing_key_priv  = "${indent(4, tls_private_key.session_signing_key.private_key_pem)}"
    worker_key_priv           = "${indent(4, tls_private_key.worker_key.private_key_pem)}"
    worker_key_pub            = "${tls_private_key.worker_key.public_key_openssh}"
  }
}

resource "local_file" "values" {
  content  = "${data.template_file.values.rendered}"
  filename = "${path.module}/.helm-config/${terraform.workspace}/values.yaml"
}

resource "aws_iam_user" "concourse_user" {
  name = "${terraform.workspace}-concourse-user"
  path = "/tools/concourse/"
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
      "iam:ListAccessKeys",
      "iam:CreateAccessKey",
      "iam:GetPolicyVersion",
      "iam:CreatePolicy",
      "iam:AttachUserPolicy",
      "iam:GetPolicy",
      "iam:ListEntitiesForPolicy",
      "iam:PutUserPolicy",
      "iam:GetUserPolicy",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*",
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
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:CreateRole",
    ]

    resources = [
      "*",
    ]
  }

  

}

resource "aws_iam_policy" "policy" {
  name        = "${terraform.workspace}-concourse-user-policy"
  path        = "/tools/concourse/"
  policy      = "${data.aws_iam_policy_document.policy.json}"
  description = "Policy for ${terraform.workspace}-concourse-user"
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "attached-policy"
  users      = ["${aws_iam_user.concourse_user.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "kubernetes_namespace" "concourse" {
  metadata {
    name = "concourse"
  }
}

resource "kubernetes_namespace" "concourse_main" {
  metadata {
    name = "concourse-main"
  }
}

resource "kubernetes_secret" "concourse_aws_credentials" {
  depends_on = ["kubernetes_namespace.concourse_main"]

  metadata {
    name      = "aws"
    namespace = "concourse-main"
  }

  data {
    access-key-id     = "${aws_iam_access_key.iam_access_key.id}"
    secret-access-key = "${aws_iam_access_key.iam_access_key.secret}"
  }
}

resource "kubernetes_secret" "concourse_basic_auth_credentials" {
  depends_on = ["kubernetes_namespace.concourse_main"]

  metadata {
    name      = "concourse-basic-auth"
    namespace = "concourse-main"
  }

  data {
    username = "${random_string.basic_auth_username.result}"
    password = "${random_string.basic_auth_password.result}"
  }
}
