 * Github auth using the plugin and setup instructions from https://github.com/larscheid-schmitzhermes/nexus3-github-oauth-plugin
   * log in restricted to `ministryofjustice` org in `githuboauth.properties`
   * for Roles, do note that org/team identifier is case sensitive, so `ministryofjustice/WebOps`
 * S3 blob storage using the plugin from https://github.com/sonatype/nexus-blobstore-s3
 * k8s install using `helm install --namespace development --name nexus -f values.yaml stable/sonatype-nexus`
 * after initial login with admin/admin123 (change it), head to Realms and drag Github after Local
 * create roles matching Github team names
