terraform {
  backend "s3" {
    bucket = "cp-test-2-environments"
    region = "eu-west-1"

    key = "cloud-platform-test-2/main/build-environments/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}
