output "subnet_group" {
  value = "${aws_db_subnet_group.concourse.name}"
}

output "db_instance_id" {
  value = "${aws_db_instance.concourse.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.concourse.address}"
}
