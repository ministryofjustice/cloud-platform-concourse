terraform {
  backend "s3" {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "concourse-terraform/pipelines/live-1/main/build-environments/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}
