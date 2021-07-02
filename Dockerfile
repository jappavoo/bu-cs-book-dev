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
#  emacs
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find 
RUN apt-get -y install build-essential texinfo libncurses-dev ssh emacs-nox cc65 bsdmainutils file man-db manpages-posix manpages-dev manpages-posix-dev findutils

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
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

# Add jupyter-book development support
RUN pip install -U jupyter-book

# Add ghp-import so that we can publish books to github easily
RUN pip install -U ghp-import

# As per jupyter book instructions for interactive support
RUN pip install -U jupytext nbgitpuller

# added matplotlib
RUN pip install -U matplotlib

# adding spell checker
RUN pip install -U jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable spellchecker/main

USER root
# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
RUN yes | unminimize || true

USER $NB_USER

