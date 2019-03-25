terraform {
  backend "s3" {
    bucket               = "cloud-platform-terraform-state"
    region               = "eu-west-1"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "concourse-terraform"
  }
}

provider "aws" {
  profile = "moj-cp"
  region  = "eu-west-2"
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "cloud-platform/live-1/terraform.tfstate"
  }
}

/*
 * Create RDS database for concourse.
 *
 */

resource "aws_security_group" "concourse" {
  name        = "${terraform.workspace}-concourse"
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
    Name = "${terraform.workspace}-concourse"
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
    basic_auth_username       = "${random_string.basic_auth_username.result}"
    basic_auth_password       = "${random_string.basic_auth_password.result}"
    github_auth_client_id     = "${local.secrets["github_auth_client_id"]}"
    github_auth_client_secret = "${local.secrets["github_auth_client_secret"]}"
    concourse_hostname        = "concourse.apps.${data.terraform_remote_state.cluster.cluster_domain_name}"
    github_org                = "${local.secrets["github_org"]}"
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

module "concourse_user_cp" {
  source      = "concourse-aws-user"
  aws_profile = "moj-cp"
}

resource "kubernetes_secret" "concourse_aws_credentials" {
  depends_on = ["helm_release.concourse"]

  metadata {
    name      = "aws-${terraform.workspace}"
    namespace = "concourse-main"
  }

  data {
    access-key-id     = "${module.concourse_user_cp.id}"
    secret-access-key = "${module.concourse_user_cp.secret}"
  }
}

module "concourse_user_pi" {
  source      = "concourse-aws-user"
  aws_profile = "moj-pi"
}

resource "kubernetes_secret" "concourse_aws_credentials_pi" {
  depends_on = ["helm_release.concourse"]

  metadata {
    name      = "aws-live-0"
    namespace = "concourse-main"
  }

  data {
    access-key-id     = "${module.concourse_user_pi.id}"
    secret-access-key = "${module.concourse_user_pi.secret}"
  }
}

resource "kubernetes_secret" "concourse_basic_auth_credentials" {
  depends_on = ["helm_release.concourse"]

  metadata {
    name      = "concourse-basic-auth"
    namespace = "concourse-main"
  }

  data {
    username = "${random_string.basic_auth_username.result}"
    password = "${random_string.basic_auth_password.result}"
  }
}

resource "helm_release" "concourse" {
  name          = "concourse"
  namespace     = "concourse"
  repository    = "stable"
  chart         = "concourse"
  version       = "${var.concourse_chart_version}"
  recreate_pods = true

  values = [
    "${data.template_file.values.rendered}",
  ]

  lifecycle {
    ignore_changes = ["keyring"]
  }
}

resource "kubernetes_config_map" "concourse_mainteam_config_map" {
  metadata {
    name      = "role-config"
    namespace = "concourse"
  }

  data {
    "roles.yml" = <<ROLES
roles:
- name: owner
  local:
    users: [ "${random_string.basic_auth_username.result}" ]
- name: member
  github:
    teams: [ "${local.secrets["github_teams"]}" ]
- name: viewer
  github:
    orgs: [ "${local.secrets["github_org"]}" ]
ROLES
  }
}
