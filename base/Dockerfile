ARG BASE_VERSION
ARG BASE_IMAGE
FROM ${BASE_IMAGE}${BASE_VERSION}
#FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook${BASE_VERSION}

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

# End 
# adding 
USER 1001
