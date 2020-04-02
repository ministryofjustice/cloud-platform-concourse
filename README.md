# cloud-platform-concourse

Concourse CI for the Cloud Platform

## Install / Upgrade

In order to setup concourse initially on a cluster, you will need to have `terraform` (version >= 0.12.13), `kubectl` and `helm` installed.

1. Select the name of the cluster you want to install Concourse CI on, as it appears in the terraform workspaces [here](https://github.com/ministryofjustice/cloud-platform-infrastructure/tree/master/terraform/cloud-platform).

  `kubectl config use-context <cluster-name>.cloud-platform.service.justice.gov.uk`

Or, if you have `kops` installed:

  `kops export kubecfg <cluster-name>.cloud-platform.service.justice.gov.uk`

2. cd to the `resources` directory, containing the terraform source code

`cd resources`

3. Select the workspace to match the cluster you want to nstall Concourse CI on

  `terraform workspace select <cluster-name>`

Use `new` instead of `select` if the workspace doesn't exist.

4. Edit `secrets.tf` and add a configuration block for the new cluster, if one does not already exist.



Create a file <cluster-name>.tfvars file for example `conc_1.tfvars`, copy and amend with details related to the cluster.
```
vpc_name     = "<vpc name>"
cluster_name = "<cluster name>"
kops_or_eks  = "<eks or kops>"
is_prod      = false
```

An example would look like this:

```
vpc_name     = "conc_1"
cluster_name = "conc_1"
kops_or_eks  = "eks"
is_prod      = false

```
5. Run terraform to bootstraps a Concourse deployment on a Kubernetes cluster <cluster-name> using the Helm package manager. You can use the `.tfvars` file created about to pass parameters such as vpc, cluster name.

```
terraform init
terraform apply -var-file=conc_1.tfvars
```

6. Access your concourse instance

Your concourse instance should be accessible at the URL:

`https://concourse.apps.<cluster-name>.cloud-platform.service.justice.gov.uk/`

However, you will not be able to login via github unless you:

1. create a new github app. for your concourse instance
2. have a github admin add the app to the ministryofjustice organisation
3. update `resources/secrets.tf` and change the `github_auth_client_id` to the ID of the new app.

You can login using basic authentication. The username and password will be in
the secret named `concourse-basic-auth` in the `concourse-main` namespace.

Be aware that the basic auth. credentials give you full admin access to your
concourse instance.

## Removing

Currently a manual task:

1. Remove `helm` deployment:

```sh
helm --kube-context=<context> --tiller-namespace kube-system delete --purge concourse
```

2. Destroy terraform managed resources:

```sh
cd resources
terraform workspace select <cluster-name>
terraform destroy -var-file=<tfvars file where the details of vpc an cluster name>
terraform workspace select default
terraform workspace delete <cluster-name>
```

3. Destroy the namespaces

```
kubectl delete namespace concourse-main
kubectl delete namespace concourse
```

## Pipelines

Pipeline configuration can be managed in this repository, please read the documentation [here](pipelines/README.md).
