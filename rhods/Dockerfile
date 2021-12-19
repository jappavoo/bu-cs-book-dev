FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook@sha256:8dd0326cdb8f89dedd1a858ed7469fce77a84a444c2656f134896ab204491216

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
#  joe
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find
#  we add xterm to pick up resize :-(

# build-essential
RUN yum -y install texinfo ncurses-devel vim emacs-nox \
    joe cc65 man-db man-pages bc xterm gdb cmake gcc-c++ && \
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

USER 1001

RUN pip install requirements.txt
