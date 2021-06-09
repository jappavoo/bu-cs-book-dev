FROM jupyter/minimal-notebook:latest

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root
RUN apt-get -y update 
RUN apt-get -y install texinfo libncurses-dev ssh emacs-nox
RUN cd /tmp && wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.gz && tar -zxf gdb-10.2.tar.gz && cd gdb-10.2 && ./configure --prefix /usr/local --enable-tui=yes && make -j 4 && make install
RUN cd /tmp && rm -rf gdb-10.2 && rm gdb-10.2.tar.gz
 
USER $NB_USER

# If you do switch to root, always be sure to add a "USER $NB_USER" command at the end of the
# file to ensure the image runs as a unprivileged user by default.

# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.

# Add RISE 5.4.1 to the mix as well so user can show live slideshows from their notebooks
# More info at https://rise.readthedocs.io
# Note: Installing RISE with --no-deps because all the neeeded deps are already present.
RUN conda install rise --no-deps --yes

# Add Bash kernel 
RUN conda install -c conda-forge bash_kernel 


