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
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find 
RUN apt-get -y install build-essential texinfo libncurses-dev vim ssh emacs-nox cc65 bsdmainutils file man-db manpages-posix manpages-dev manpages-posix-dev findutils

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
#RUN conda install rise --no-deps --yes
RUN pip install -U RISE

# Add Bash kernel 
#RUN conda install -c conda-forge bash_kernel 
RUN pip install --upgrade bash_kernel
RUN python -m bash_kernel.install

# Add jupyter-book development support
#RUN conda install -c conda-forge jupyter-book 
RUN pip install --upgrade jupyter-book

# Add ghp-import so that we can publish books to github easily
#RUN conda install -c conda-forge ghp-import
RUN pip install --upgrade ghp-import

# As per jupyter book instructions for interactive support
#RUN conda install jupytext -c conda-forge
RUN pip install --upgrade jupytext 

#RUN conda install -c conda-forge nbgitpuller 
RUN pip install --upgrade nbgitpuller

# enable classic notebook nbextensions
#RUN conda install -c conda-forge jupyter_contrib_nbextensions
RUN pip install --upgrade jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --user

# ipywidgets not sure if this is already included but install
#RUN conda install -c conda-forge widgetsnbextension
RUN pip install --upgrade widgetsnbextension
#RUN conda install -c anaconda ipywidgets 
RUN pip install --upgrade ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension

# added matplotlib
#RUN conda install -c conda-forge matplotlib 
RUN pip install --upgrade matplotlib

# added pandas
#RUN conda install -c anaconda pandas
RUN pip install --upgrade pandas

# added plotly express
#RUN conda install -c plotly plotly_express
RUN pip install --upgrade plotly
RUN pip install --upgrade plotly_express

# turn on spellchecker extension
RUN jupyter nbextension enable spellchecker/main

# enable split cell
RUN jupyter nbextension enable splitcell/splitcell

# enable hide-all
RUN jupyter nbextension enable hide_input_all/main

# enable hide
RUN jupyter nbextension enable hide_input/main 

USER root
# as a hack we are going to try changing group id of /home/joyvan to be root to see if I can trick things into
# working on the moc
RUN chgrp -R root /home/jovyan

USER $NB_USER
# turn off login messages and suppress sudo group check in /etc/bash.bashrc
# was causing unnecessary error messages due to gid not in /etc/groups on operate-first
RUN touch ~/.hushlogin

# use a short prompt to improve default behaviour in presentations
RUN echo "export PS1='\$ '" >> ~/.bashrc

# work around bug when term is xterm and emacs runs in xterm.js -- causes escape characters in file
RUN echo "export TERM=linux" >> ~/.bashrc

# finally remove default working directory from joyvan home
RUN rmdir ~/work

#USER root
# turned off for the moment to minimize size
# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
#RUN yes | unminimize || true

#USER $NB_USER
