# build-environments

## Usage

This folder deploys the resources needed for the concourse pipelines to run on EKS Manager cluster.

### concourse-build-environments

In order for the pipelines to access the EKS manager cluster and live-1, serviceaccount with cluster-admin roleBindings are created. The secrets generated from the serviceaccount are updated to their corresponding clusters in `terraform.tfvars` manually. 

This folder also bootstrap s3 bucket `cloud-platform-concourse-kubeconfig`, generate the kubeconfig with the format defined in `/templates` folder using the values from `terraform.tfvars`
