# concourse-CP
CI for Kubernetes cluster CP

 * ensure valid AWS credentials are defined on your laptop in ~/.aws
 * export AWS_DEFAULT_REGION and AWS_PROFILE
 * start with `terraform plan` in the concourse-rds dir
 * use the DB URL output in concourse/values.yaml
 * ensure the URL and tokens defined in https://github.com/settings/developers  match the settings in values.yaml
 * ensure you have valid k8s credentials in ~/.kube
 * `helm install --namespace $ns --name concourse -f values.yaml stable/concourse`
 * watch progress with `watch kubectl get pods --namespace $ns` and `kubectl logs --namespace $ns concourse-web-$id -f`
 * TODO: figure out the 504s
 * apply changes with `helm upgrade -f values.yaml concourse stable/concourse`
 * to wipe everything (handle with care):
   * `terraform destroy` in each folder
   * `helm delete --purge concourse`
 * Docker registry:
   * Artifactory: `helm install --namespace $ns --name artifactory --set ingress.enabled=true --set ingress.hosts[0]="artifactory.$domain" --set nginx.enabled=false --set artifactory.externalPort=80 --set artifactory.image.repository=docker.bintray.io/jfrog/artifactory-oss stable/artifactory`
   * Nexus (from its folder): `helm install --namespace development --name nexus -f values.yaml stable/sonatype-nexus`
