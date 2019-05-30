terraform {
  backend "s3" {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "concourse-pipelines/live-1/main/tzcronjobber/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}
