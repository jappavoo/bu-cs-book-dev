ARG BASE_VERSION
ARG BASE_IMAGE
FROM ${BASE_IMAGE}${BASE_VERSION}

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root
RUN apt-get -y update --fix-missing

# minimal-notebook no longer inludes compiler and other tools we we install them and some other standard unix develpment tools
#  stuff for gdb texinfo libncurses 
#  ssh
#  vim 
#  emacs
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find
#  less
#  bc arbitrary precision and base calculator language
#  rsync to be able to files with a remote site
#  valgrind, address sanitizer and undefined sanitizer for memory checking and debugging

RUN apt-get -y install build-essential texinfo libncurses-dev vim ssh emacs-nox cc65 bsdmainutils file man-db manpages-posix manpages-dev manpages-posix-dev findutils less bc rsync valgrind libasan5 libubsan1

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
RUN cd /tmp && wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.gz && tar -zxf gdb-10.2.tar.gz && cd gdb-10.2 && ./configure --prefix /usr/local --enable-tui=yes && make -j 4 && make install
RUN cd /tmp && rm -rf gdb-10.2 && rm gdb-10.2.tar.gz

# we add xterm to pick up resize :-(
RUN apt-get -y --fix-missing install xterm || true

# adding moria for old time sake
RUN apt-get install -y moria

# adding acl support so that we can discuss / introduce it
RUN apt-get install -y acl

# adding cmake to facilitate working with wasm via wabt
RUN apt-get update
RUN apt-get install -y cmake 

# adding zip so that gradescope autograders can be built
RUN apt-get install -y zip

# adding ascii2binary to make some examples easier
RUN apt-get install -y ascii2binary

# adding strace for sycall tracing
RUN apt-get install -y strace

RUN dpkg --add-architecture i386 && apt-get -y update && apt-get install -y lib32gcc-9-dev libedit-dev:i386

# support linux kernel building
RUN apt-get -y update
RUN apt-get -y install  bison flex libssl-dev libelf-dev

# add dwarf dump to allow exploration of debug info in a binary
# In the end I think I am happier using elfread with --debug-dump=decodedline like functionality
# RUN apt-get install -y dwarfdump

# add netwide assembler to make stream disassembling easier
RUN apt-get install -y nasm

# add qemu-system-aarch64 to permit arm64 assemmbly examples
# need qemu 5 or higher to pickup support for compressed images
#  - so need to get this from backports given that jupyter-minimal is from ubuntu focal for which qemu 4 is the default
#  - add backports
#  - install qemu from backport -- only installing aarch64 and tools (eg qemu-immg) as that is all we need
RUN apt update -y && apt install -y software-properties-common && apt update -y && add-apt-repository -y ppa:canonical-server/server-backports && apt-get install -y  -t focal-backports  qemu-system-aarch64

RUN apt-get install -y socat rlwrap

USER $NB_USER

# copy aarch64vm into the image
COPY aarch64vm /home/aarch64vm

USER root
RUN chown -R jovyan /home/aarch64vm
RUN chgrp -R root /home/aarch64vm && chmod -R g+rX /home/aarch64vm && chmod g+w /home/aarch64vm && chmod g+w /home/aarch64vm/*

USER $NB_USER

