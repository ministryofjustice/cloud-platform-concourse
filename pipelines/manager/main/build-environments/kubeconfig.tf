variable "clusters" {
  default = []
}

data "template_file" "clusters" {
  count = length(var.clusters)

  template = file("${path.module}/templates/cluster.tpl")

  vars = {
    name    = var.clusters[count.index]["name"]
    host    = var.clusters[count.index]["host"]
    ca_data = var.clusters[count.index]["ca_data"]
  }
}

data "template_file" "users" {
  count = length(var.clusters)

  template = file("${path.module}/templates/user.tpl")

  vars = {
    name  = var.clusters[count.index]["name"]
    token = var.clusters[count.index]["token"]
  }
}

data "template_file" "contexts" {
  count = length(var.clusters)

  template = file("${path.module}/templates/context.tpl")

  vars = {
    name = var.clusters[count.index]["name"]
  }
}

resource "aws_s3_bucket" "kubeconfig" {
  bucket = "cloud-platform-concourse-kubeconfig"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "kubeconfig" {
  key    = "kubeconfig"
  bucket = aws_s3_bucket.kubeconfig.id

  content = <<EOF
apiVersion: v1
kind: Config
current-context: ""

clusters:
${join("", data.template_file.clusters.*.rendered)}
contexts:
${join("", data.template_file.contexts.*.rendered)}
users:
${join("", data.template_file.users.*.rendered)}
EOF


  server_side_encryption = "AES256"
}

