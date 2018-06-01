variable "rds_storage" {
  default     = "10"
  description = "RDS storage size in GB"
}

variable "rds_postgresql_version" {
  default     = "9.6.8"
  description = "Version of PostgreSQL RDS to use"
}

variable "rds_instance_class" {
  default     = "db.t2.micro"
  description = "RDS instance class"
}

variable "db_name" {
  default     = "concourse"
  description = "PostgreSQL DB name"
}

variable "concourse_image_tag" {
  default     = "3.11.0"
  description = "The docker image tag to use"
}

variable "concourse_hostname_prefix" {
  default     = "concourse.apps"
  description = "With the cluster domain appended, it should form the hostname where concourse is exposed"
}
