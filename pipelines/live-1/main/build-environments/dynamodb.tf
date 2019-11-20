// Create a DynamoDB table so we can lock the terraform state of each
// namespace in the cloud-platform-environments repository, as we
// `terraform apply` it.
//
// This table name is referenced from the environments repo, so that
// terraform can use it to lock the state of each namespace.

resource "aws_dynamodb_table" "cloud-platform-environments-terraform-lock" {
  name           = "cloud-platform-environments-terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  provider = aws.ireland

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table for namespaces in the cloud-platform-environments repository"
  }
}

