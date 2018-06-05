output "iam_user_name" {
  description = "user name for concourse user account"
  value       = "${aws_iam_user.concourse-user.name}"
}

output "AWS_IAM_ACCESS_KEY" {
  description = "access key id for concourse user account"
  value       = "${aws_iam_access_key.iam_access_key.id}"
}

output "AWS_IAM_SECRET_KEY" {
  description = "secret key for concourse user account"
  value       = "${aws_iam_access_key.iam_access_key.secret}"
}

output "user_arn" {
  description = "arn for iam user"
  value       = "${aws_iam_user.concourse-user.arn}"
}