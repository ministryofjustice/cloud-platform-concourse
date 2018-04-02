FROM cloudsc/nexus3-blobstore-s3:3.8.0

USER root
RUN yum -y update
RUN yum -y install wget unzip 
RUN mkdir -p /opt/sonatype/nexus/system/com/larscheidschmitzhermes/ &&\
wget -O /opt/sonatype/nexus/system/com/larscheidschmitzhermes/nexus3-github-oauth-plugin.zip https://github.com/larscheid-schmitzhermes/nexus3-github-oauth-plugin/releases/download/2.0.1/nexus3-github-oauth-plugin.zip &&\
unzip /opt/sonatype/nexus/system/com/larscheidschmitzhermes/nexus3-github-oauth-plugin.zip -d /opt/sonatype/nexus/system/com/larscheidschmitzhermes/ &&\
echo "mvn\:com.larscheidschmitzhermes/nexus3-github-oauth-plugin/2.0.1 = 200" >> /opt/sonatype/nexus/etc/karaf/startup.properties
COPY githuboauth.properties /opt/sonatype/nexus/etc/githuboauth.properties
