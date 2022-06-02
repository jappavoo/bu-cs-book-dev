ARG VERSION
ARG BASE_IMAGE
FROM ${BASE_IMAGE}:${VERSION}

USER root

# from http://docs.projectatomic.io/container-best-practices/
RUN [ -e /etc/dnf/dnf.conf ] && sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf || true
RUN dnf -y reinstall "*"

USER 1001
