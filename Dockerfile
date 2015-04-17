## -*- docker-image-name: "armbuild/scw-distrib-centos:latest" -*-
FROM armbuild/centos-img:merlinthp-2015-03-16
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Environment
ENV SCW_BASE_IMAGE armbuild/centos-img:merlinthp-2015-03-16


# Patch rootfs for docker-based builds
RUN curl -Lkq http://j.mp/scw-skeleton | FLAVORS=common,docker-based bash -e
RUN /usr/local/sbin/builder-enter


# Patch rootfs
ADD ./patches/etc/ /etc/