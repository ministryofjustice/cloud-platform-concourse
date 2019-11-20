# cloud-platform-concourse

Concourse CI for the Cloud Platform

## Install / Upgrade

In order to setup concourse initially on a cluster, you will need to have `terraform` (version >= 0.12.13), `kubectl` and `helm` installed.

1. Select the name of the cluster you want to install Concourse CI on, as it appears in the terraform workspaces [here](https://github.com/ministryofjustice/cloud-platform-infrastructure/tree/master/terraform/cloud-platform).

  `kubectl config use-context <cluster-name>.cloud-platform.service.justice.gov.uk`

Or, if you have `kops` installed:

  `kops export kubecfg <cluster-name>.cloud-platform.service.justice.gov.uk`

2. Select the workspace to match the cluster you want to nstall Concourse CI on

  `terraform workspace select <cluster-name>`

3. Edit `resources/secrets.tf` and add a configuration block for the new cluster, if one does not already exist.


4. Run terraform to bootstraps a Concourse deployment on a Kubernetes cluster <cluster-name> using the Helm package manager.
   
   `terraform apply`

Two namespaces are created: `concourse` and `concourse-main`. Please make sure you define them in the [environments repository](https://github.com/ministryofjustice/cloud-platform-environments).

*NOTE*: Due to the way `helm` manages namespaces for concourse secrets (`concourse-main` in this case), it will fail on the first run of the setup script. If this occurs, with an error message complaining about the existence of the `concourse-main` namespace, please run it a second time.

## Removing
Currently a manual task:
1. Remove `helm` deployment:
```sh
helm --kube-context=<context> --tiller-namespace kube-system delete --purge concourse
```
2. Destroy terraform managed resources:
```sh
cd resources
terraform select workspace <cluster-name>
terraform destroy
terraform select workspace default
terraform workspace delete <cluster-name>
```

The created namespaces are not deleted by `helm` but `terraform` *does* manage the two starting ones (`concourse` and `concourse-main`) and will delete them during `destroy`.

## Pipelines
Pipeline configuration can be managed in this repository, please read the documentation [here](pipelines/README.md).
