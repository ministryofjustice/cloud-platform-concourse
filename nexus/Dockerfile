FROM sonatype/nexus3:3.9.0

USER root
RUN yum -y update
RUN yum -y install wget unzip 

ENV S3_BLOBSTORE_VERSION 1.2.1-SNAPSHOT
ENV NEXUS_HOME /opt/sonatype/nexus

COPY nexus-blobstore-s3-${S3_BLOBSTORE_VERSION}.jar ${NEXUS_HOME}/system/org/sonatype/nexus/nexus-blobstore-s3/${S3_BLOBSTORE_VERSION}/

RUN sed -i.bak \
  -e "/nexus-blobstore-file/a\\"$'\n'"<bundle>mvn:org.sonatype.nexus/nexus-blobstore-s3/${S3_BLOBSTORE_VERSION}</bundle>" \
  ${NEXUS_HOME}/system/org/sonatype/nexus/assemblies/nexus-base-feature/*/nexus-base-feature-*-features.xml \
  ${NEXUS_HOME}/system/org/sonatype/nexus/assemblies/nexus-core-feature/*/nexus-core-feature-*-features.xml

RUN mkdir -p /opt/sonatype/nexus/system/com/larscheidschmitzhermes/ &&\
wget -O /opt/sonatype/nexus/system/com/larscheidschmitzhermes/nexus3-github-oauth-plugin.zip https://github.com/larscheid-schmitzhermes/nexus3-github-oauth-plugin/releases/download/2.0.1/nexus3-github-oauth-plugin.zip &&\
unzip /opt/sonatype/nexus/system/com/larscheidschmitzhermes/nexus3-github-oauth-plugin.zip -d /opt/sonatype/nexus/system/com/larscheidschmitzhermes/ &&\
echo "mvn\:com.larscheidschmitzhermes/nexus3-github-oauth-plugin/2.0.1 = 200" >> /opt/sonatype/nexus/etc/karaf/startup.properties
COPY githuboauth.properties /opt/sonatype/nexus/etc/githuboauth.properties
