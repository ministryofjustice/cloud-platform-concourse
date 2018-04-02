FROM centos
RUN yum -y update && yum -y install epel-release && yum -y update
RUN yum -y install python34-pip && pip3 install --upgrade pip
RUN pip3 install flask request PyGithub
RUN mkdir /webhook
COPY app/ /webhook/
EXPOSE 8080
CMD ["/usr/bin/python3", "/webhook/github_concourse.py"]
