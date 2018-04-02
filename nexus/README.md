 * Github auth using the plugin and setup instructions from https://github.com/larscheid-schmitzhermes/nexus3-github-oauth-plugin
   * log in restricted to `ministryofjustice` org in `githuboauth.properties`
   * for Roles, do note that org/team identifier is case sensitive, so `ministryofjustice/WebOps`
 * S3 blob storage uing the plugin from https://github.com/sonatype/nexus-blobstore-s3 and Docker image from https://hub.docker.com/r/cloudsc/nexus3-blobstore-s3/tags/
 * k8s install using `helm install --namespace development --name nexus -f values.yaml stable/sonatype-nexus`
