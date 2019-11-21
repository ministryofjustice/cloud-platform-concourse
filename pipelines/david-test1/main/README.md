# Concourse

## Login

```
fly -t david-test1 login --concourse-url https://concourse.apps.david-test1.cloud-platform.service.justice.gov.uk
```

## Create/update pipeline

```
fly -t david-test1 set-pipeline -p plan -c pipelines/david-test1/main/plan-environments.yaml
```

## Setup github personal access token secret

```
kubectl -n concourse-main create secret generic digitalronin-environments-pr-git-access-token
kubectl -n concourse-main edit secret generic digitalronin-environments-pr-git-access-token
```

Add `data.value` of base64-encoded github personal access token

## Setup AWS secrets

Copy the aws-live-1 secret from the live-1 cluster.

## Create kube config for the pipeline

```
rm ~/.kube/config  # Assuming there's nothing in there you care about
kops export kubecfg david-test1.cloud-platform.service.justice.gov.uk
aws s3 cp ~/.kube/config s3://cloud-platform-concourse-kubeconfig/david-test1-config
```

In your pipeline yaml file, replace this:

    aws s3 cp s3://cloud-platform-concourse-kubeconfig/kubeconfig /tmp/kubeconfig

...with this

    aws s3 cp s3://cloud-platform-concourse-kubeconfig/david-test1-config /tmp/kubeconfig

