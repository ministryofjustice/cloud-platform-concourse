terraform {
  backend "s3" {
    bucket = "moj-cp-k8s-investigation-concourse-terraform"
    region = "eu-west-1"

    key = "pipelines/cloud-platform-live-0/main/build-environments/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}
