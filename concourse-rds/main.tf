resource "aws_db_instance" "concourse" {
  depends_on             = ["aws_security_group.concourse"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.concourse.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.concourse.id}"
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "concourse" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.subnet_1_id}", "${var.subnet_2_id}"]
}
