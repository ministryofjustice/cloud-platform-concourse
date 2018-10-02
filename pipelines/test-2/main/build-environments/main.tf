terraform {
  backend "s3" {
    bucket = "cp-test-2-environments"
    region = "eu-west-1"

    key = "test-2/pipeline/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}
