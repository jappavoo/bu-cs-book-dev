FROM gradescope/auto-builds:ubuntu-20.04

USER root
RUN apt-get -y update --fix-missing

# minimal-notebook no longer inludes compiler and other tools we we install them and some other standard unix develpment tools
#  stuff for gdb texinfo libncurses 
#  ssh
#  vim 
#  find 
RUN apt-get -y install build-essential texinfo libncurses-dev vim ssh bsdmainutils file findutils less bc 

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
RUN cd /tmp && wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.gz && tar -zxf gdb-10.2.tar.gz && cd gdb-10.2 && ./configure --prefix /usr/local --enable-tui=yes && make -j 4 && make install
RUN cd /tmp && rm -rf gdb-10.2 && rm gdb-10.2.tar.gz

# adding zip so that gradescope autograders can be built
RUN apt-get install -y zip

# adding ascii2binary to make some examples easier
RUN apt-get install -y ascii2binary

RUN dpkg --add-architecture i386 && apt-get -y update && apt-get install -y lib32gcc-9-dev libedit-dev:i386

RUN apt-get update && apt-get install -y valgrind libasan5 libubsan1

RUN apt-get update && \
    apt-get install -y dos2unix && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD source /autograder/source

RUN cp /autograder/source/run_autograder /autograder/run_autograder

# Ensure that scripts are Unix-friendly and executable
RUN dos2unix /autograder/run_autograder /autograder/source/setup.sh
RUN chmod +x /autograder/run_autograder

# Do whatever setup was needed in setup.sh, including installing apt packages
# Cleans up the apt cache afterwards in the same step to keep the image small
RUN apt-get update && \
    bash /autograder/source/setup.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

