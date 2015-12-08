FROM tianon/centos:6.5
MAINTAINER jun.yamada jun.16@mac.com

ADD Centos-Source.repo /etc/yum.repos.d/Centos-Source.repo

RUN yum update -y

RUN yum install -y tar bzip2 yum-utils rpm-build

RUN yum-builddep -y pam
RUN yumdownloader --source pam
RUN rpmbuild --rebuild  --define 'WITH_AUDIT 0' --define 'dist +noaudit' pam*.src.rpm
RUN rpm -Uvh --oldpackage ~/rpmbuild/RPMS/*/pam*+noaudit*.rpm

RUN rm -f /*.rpm
RUN rm -rf ~/rpmbuild

USER root

# install dev tools
RUN yum install -y curl which tar sudo openssh-server openssh-clients rsync | true
RUN yum update -y libselinux | true

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-7u71-linux-x64.rpm
RUN rm jdk-7u71-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

# python
RUN yum -y install python-setuptools
RUN easy_install pip


# elasticsearch
## newer version at 07/Dec 2015
RUN curl -s https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.0/elasticsearch-2.1.0.tar.gz | tar -xz -C /usr/local/
# 1.7.2
RUN curl -s https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.tar.gz | tar -xz -C /usr/local/

# kibana
## newer version at 07/Dec 2015
RUN curl -s https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz | tar -xz -C /usr/local/
# 4.3.0
RUN curl -s https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz | tar -xz -C /usr/local/

# curator
RUN pip install elasticsearch-curator


# elasticsearch port
EXPOSE 9200

# kibana port
EXPOSE 5601
