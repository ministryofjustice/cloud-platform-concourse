variable "rds_storage" {
  default     = "50"
  description = "RDS storage size in GB"
}

variable "rds_postgresql_version" {
  default     = "10.6"
  description = "Version of PostgreSQL RDS to use"
}

variable "rds_instance_class" {
  default     = "db.t2.micro"
  description = "RDS instance class"
}

variable "concourse_image_tag" {
  default     = "5.0.0"
  description = "The docker image tag to use"
}

variable "concourse_chart_version" {
  default     = "5.0.0"
  description = "The Helm chart version"
}

