#!/bin/sh

set -o pipefail
set -o errexit

usage() {
  printf "${0} <cluster-name>\n"
}

if [ $# != 1 ]; then
  usage
  exit 1
fi

cd resources

terraform init
terraform workspace select "${1}"
terraform apply -auto-approve

helm install \
  --namespace concourse \
  --name concourse \
  -f ".helm-config/${1}/values.yaml" \
  stable/concourse
