terraform {
  backend "s3" {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "concourse-pipelines/live-1/main/build-environments/terraform.tfstate"
  }
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubernetes" {
  alias          = "live-1"
  config_context = "live-1.cloud-platform.service.justice.gov.uk"
}

provider "kubernetes" {
  alias          = "manager"
  config_context = "arn:aws:eks:eu-west-2:754256621582:cluster/manager"
}

resource "kubernetes_service_account" "manager" {
  metadata {
    name      = "concourse-build-environments"
    namespace = "kube-system"
  }

  automount_service_account_token = false

  provider = kubernetes.manager
}

resource "kubernetes_service_account" "live_1" {
  metadata {
    name      = "concourse-build-environments"
    namespace = "kube-system"
  }
  
  automount_service_account_token = false

  provider = kubernetes.live-1
}

