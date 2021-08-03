FROM jupyter/minimal-notebook:latest

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root
RUN apt-get -y update 

# minimal-notebook no longer inludes compiler and other tools we we install them and some other standard unix develpment tools
#  stuff for gdb texinfo libncurses 
#  ssh
#  vim 
#  emacs
#  joe
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find 
RUN apt-get -y install build-essential texinfo libncurses-dev vim ssh emacs-nox joe cc65 bsdmainutils file man-db manpages-posix manpages-dev manpages-posix-dev findutils

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
RUN cd /tmp && wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.gz && tar -zxf gdb-10.2.tar.gz && cd gdb-10.2 && ./configure --prefix /usr/local --enable-tui=yes && make -j 4 && make install
RUN cd /tmp && rm -rf gdb-10.2 && rm gdb-10.2.tar.gz
 
USER $NB_USER
