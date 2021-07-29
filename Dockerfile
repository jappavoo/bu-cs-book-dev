FROM jappavoo/bu-cs-book-dev-base-unmin:latest

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.
 
USER $NB_USER

# If you do switch to root, always be sure to add a "USER $NB_USER" command at the end of the
# file to ensure the image runs as a unprivileged user by default.

# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.

# Each of these was tested by hand on the bu-cs-book-dev-unmin
# Add RISE to the mix as well so user can show live slideshows from their notebooks
# More info at https://rise.readthedocs.io
# Note: Installing RISE with --no-deps because all the neeeded deps are already present.
# # last known version: rise-5.7.1  
RUN conda install rise --yes

# Add Bash kernel 
# from https://github.com/takluyver/bash_kernel
# last known version: bash-kernel-0.7.2
RUN pip install bash_kernel
RUN python -m bash_kernel.install

# Add jupyter-book development support
# needed to use pip to get the right version
# last known version: jupyter-book-0.11.2 
RUN pip install jupyter-book

# Add ghp-import so that we can publish books to github easily
# https://pypi.org/project/ghp-import/
# ghp-import-2.0.1
RUN pip install ghp-import

# As per jupyter book instructions for interactive support
# jupyter-book requires an older version of jupyter-book
# conda seems to do the right thing
# jupytext                  1.10.3  
RUN conda install jupytext --yes

#RUN conda install -c conda-forge nbgitpuller
# https://github.com/jupyterhub/nbgitpuller
# nbgitpuller-0.10.1
RUN pip install nbgitpuller

# enable classic notebook nbextensions
# https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/install.html
# jupyter_contrib_nbextensions 0.5.1
RUN conda install jupyter_contrib_nbextensions --yes


# ipywidgets not sure if this is already included but install
# widgetsnbextension        3.5.1
RUN conda install widgetsnbextension --yes
# ipywidgets                7.6.3
RUN conda install ipywidgets --yes
RUN jupyter nbextension enable --py widgetsnbextension

# added matplotlib
# https://matplotlib.org/stable/users/installing.html
# matplotlib                3.4.2  
RUN pip install -U matplotlib

# added pandas
# https://pandas.pydata.org/pandas-docs/stable/getting_started/install.html
# pandas-1.3.1
RUN pip install pandas

# added plotly express
# https://plotly.com/python/getting-started/
# plotly-5.1.0
RUN pip install plotly
# https://pypi.org/project/plotly-express/
# plotly-express-0.4.1 
RUN pip install plotly_express

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

