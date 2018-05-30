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

variable "db_username" {
  description = "PostgreSQL DB username"
}

variable "db_password" {
  description = "PostgreSQL DB password"
}

variable "concourse_image_tag" {
  default     = "3.11.0"
  description = "The docker image tag to use"
}

variable "concourse_hostname" {
  description = "Where Concourse is accessible"
}

variable "github_auth_client_id" {
  description = "For GitHub OAuth"
}

variable "github_auth_client_secret" {
  description = "For GitHub OAuth"
}

variable "github_users" {
  type        = "list"
  description = "List of github users who are allowed to authenticate with Concourse"
}

variable "concourse_hostname_prefix" {
  default     = "concourse.apps."
  description = "With the cluster domain appended, it should form the hostname where concourse is exposed"
}
