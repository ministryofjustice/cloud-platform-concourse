#!/bin/bash
set -e

terraform plan
terraform apply -auto-approve
export u=$(terraform output db_instance_usename)
export p=$(terraform output db_instance_password)
export h=$(terraform output db_instance_address)
echo "adding the values into ../concourse/values.yaml"
perl -pi -e 's/^(\s+)postgresqlUri.*/$1postgresqlUri: postgres:\/\/$ENV{"u"}:$ENV{"p"}\@$ENV{"h"}:5432\/concourse?sslmode=disable/' ../concourse/values.yaml 
