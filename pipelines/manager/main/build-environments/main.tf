terraform {
  backend "s3" {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "concourse-pipelines/live-1/main/build-environments/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}


provider "kubernetes" {
  alias          = "live-1"
  config_context = "live-1.cloud-platform.service.justice.gov.uk"
}


# Concourse Service Account
resource "kubernetes_service_account" "live_1" {
  metadata {
    name      = "concourse-build-environments"
    namespace = "kube-system"
  }

  automount_service_account_token = false

  provider = kubernetes.live-1
}


resource "kubernetes_cluster_role_binding" "concourse_build_environments_live_1" {

  metadata {
    name = "concourse-build-environments"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.live_1.metadata.0.name
    namespace = "kube-system"
  }

  provider = kubernetes.live-1
}



