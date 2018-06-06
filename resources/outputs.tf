output "AWS_IAM_ACCESS_KEY" {
  description = "access key id for concourse user account"
  value       = "${aws_iam_access_key.iam_access_key.id}"
}

output "AWS_IAM_SECRET_KEY" {
  description = "secret key for concourse user account"
  value       = "${aws_iam_access_key.iam_access_key.secret}"
}
