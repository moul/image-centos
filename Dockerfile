## -*- docker-image-name: "armbuild/scw-distrib-centos:latest" -*-
FROM armbuild/centos-img:merlinthp-2015-03-16
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Environment
ENV SCW_BASE_IMAGE armbuild/centos-img:merlinthp-2015-03-16


# Remove big packages
# kernel, drivers, firmwares
RUN yum erase -y kernel* *-drivers *-firmware
# graphics
RUN yum erase -y GConf2 gtk* gnome-* fedora-logos xkeyboard-config xorg-* gdk* qt* libX* *fonts* plymouth*
# services
RUN yum erase -y nfs* libnfsidmap wpa_supplicant ModemManager usbutils samba-* cups* iso-codes poppler* words mozjs17
# rpmorphan | grep ^lib
RUN yum erase -y libfontenc libgusb libipa_hbac libmbim libqmi libreport-plugin-bugzilla libreport-plugin-reportuploader libxkbfile libmodman libmng alsa* dracut* avahi* postfix*
RUN rm -f /root/anaconda-ks.cfg


# Remove root password
RUN passwd -d root


# Patch rootfs for docker-based builds
RUN curl -Lkq http://j.mp/scw-skeleton | FLAVORS=common,docker-based bash -e
RUN /usr/local/sbin/builder-enter


# Patch rootfs
ADD ./patches/etc/ /etc/


# TEMPORARY DEBUG ACCESS
RUN umask 077; mkdir /root/.ssh
# moul
RUN (curl https://github.com/moul.keys; echo) >> /root/.ssh/authorized_keys \
 && (curl https://github.com/aimxhaisse.keys; echo) >> /root/.ssh/authorized_keys \
 && (curl https://github.com/kbsingh.keys; echo) >> /root/.ssh/authorized_keys \
 && (curl https://github.com/arrfab.keys; echo) >> /root/.ssh/authorized_keys \
 && (curl https://github.com/mndar.keys; echo) >> /root/.ssh/authorized_keys \
 && (curl https://github.com/merlinthp.keys; echo) >> /root/.ssh/authorized_keys


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave