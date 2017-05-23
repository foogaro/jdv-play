FROM registry.access.redhat.com/rhel:latest

MAINTAINER Foogaro <l.fugaro@gmail.com>

RUN subscription-manager register --username YOURUSERNAME --password DONOTUSEPASSWORDDOTONE
RUN subscription-manager attach --auto
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
RUN yum install -y which net-tools mlocate
RUN yum -y update && yum clean all
