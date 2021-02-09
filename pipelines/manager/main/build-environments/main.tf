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

provider "kubernetes_live_1" {
  config_path    = "~/.kube/config"
  config_context = "live-1"
}

provider "kubernetes_manager" {
  config_path    = "~/.kube/config"
  config_context = "manager"
}

resource "kubernetes_service_account" "manager" {
  metadata {
    name = "terraform-example"
  }
  secret {
    name = "${kubernetes_secret.example.metadata.0.name}"
  }
}

resource "kubernetes_service_account" "live_1" {
  metadata {
    name = "terraform-example"
  }
  secret {
    name = "${kubernetes_secret.example.metadata.0.name}"
  }
}

