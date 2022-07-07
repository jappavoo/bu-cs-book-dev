ARG BASE_VERSION
ARG BASE_IMAGE
FROM ${BASE_IMAGE}${BASE_VERSION}

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root

# minimal-notebook no longer inludes compiler and other tools we we install them
# and some other standard unix develpment tools
#  stuff for gdb texinfo libncurses 
#  ssh
#  vim 
#  emacs
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find
#  we add xterm to pick up resize :-(

# build-essential
RUN yum -y install texinfo ncurses-devel vim emacs-nox \
    cc65 man-db man-pages bc xterm gdb cmake gcc-c++ && \
    yum update --assumeyes --nobest --setopt=tsflags=nodocs && \
    yum --assumeyes clean all && \
    rm -rf /var/cache/dnf

#  adding moria for old time sake
#  sed '36d' CMakeLists.txt -> Ref: https://github.com/dungeons-of-moria/umoria/issues/44
RUN cd /tmp && wget https://github.com/dungeons-of-moria/umoria/archive/refs/tags/v5.7.15.tar.gz \
    && tar -zxf v5.7.15.tar.gz && cd umoria-5.7.15 && sed -i '36d' CMakeLists.txt \
    && cmake . && make \
    && mv umoria /opt/umoria \
    && ln -s /opt/umoria/umoria /opt/umoria/moria \
    && cd /tmp && rm -rf v5.7.15 && rm v5.7.15.tar.gz

ENV PATH=$PATH:/opt/umoria

# Changes made from June - Abirami

RUN yum -y install openssh joe strace bison flex openssl-devel elfutils-libelf \
    nasm socat rlwrap qemu-system-aarch64 libgcc.i686 libedit-devel.i686 libbsd


######### JA HACKERY #############

# simulate jupyter stacks user model so that we can get a dummy home directory setup
# see https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# Configure environment
ENV NB_USER="${NB_USER}" \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    HOME="/home/${NB_USER}"

RUN  useradd -l -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" && \
    chmod g+w /etc/passwd && \
    fix-permissions "${HOME}"

USER ${NB_UID}

# Setup work directory for backward-compatibility
#RUN mkdir "/home/${NB_USER}/work" && \
#    fix-permissions "/home/${NB_USER}"

USER root

# adding jupyter stacks style startup hook
COPY docker-stacks/base-notebook/start.sh /tmp/start.sh
RUN  mkdir /opt/app-root/jupyter-stacks && sed 's/^    exec.*/      _log "JA-OK: removed exec"/g' /tmp/start.sh > /opt/app-root/jupyter-stacks/start.sh

#COPY start-notebook.d /usr/local/bin/start-notebook.d

# add jupyter stacks hook calls as needed
RUN  [[ -a /opt/app-root/bin/setup-environ.sh ]] && echo ". /opt/app-root/jupyter-stacks/start.sh"  >>  /opt/app-root/bin/setup-environ.sh

#### ADD ARM development environment in /home
# copy aarch64vm into the image
COPY aarch64vm /home/aarch64vm

RUN chown -R jovyan /home/aarch64vm
RUN chgrp -R root /home/aarch64vm && chmod -R g+rX /home/aarch64vm && chmod g+w /home/aarch64vm && chmod g+w /home/aarch64vm/*

# End 
# adding 
USER 1001

WORKDIR "${HOME}"