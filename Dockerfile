ARG VERSION
FROM jappavoo/bu-cs-book-dev-base-unmin:${VERSION}
 
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
#RUN conda install -c conda-forge jupyter-book 
RUN pip install jupyter-book

# Add ghp-import so that we can publish books to github easily
RUN conda install -c conda-forge ghp-import

# As per jupyter book instructions for interactive support
RUN conda install jupytext -c conda-forge
RUN conda install -c conda-forge nbgitpuller 

# ipywidgets not sure if this is already included but install
RUN conda install -c conda-forge widgetsnbextension
RUN conda install -c anaconda ipywidgets 
#RUN jupyter nbextension enable --py widgetsnbextension

# added matplotlib
RUN conda install -c conda-forge matplotlib 

# added pandas
RUN conda install -c anaconda pandas

# added plotly express
RUN conda install -c plotly plotly_express


# enable classic notebook nbextensions
RUN conda install -c conda-forge jupyter_contrib_nbextensions

# turn on spellchecker extension
RUN jupyter nbextension enable spellchecker/main

# enable split cell
RUN jupyter nbextension enable splitcell/splitcell

# enable hide-all
RUN jupyter nbextension enable hide_input_all/main

# enable hide
RUN jupyter nbextension enable hide_input/main 

# enable the use of python in markdown cells python-markdown/main
# could not get this to work
#RUN jupyter nbextension enable python-markdown/main 

# customize look and feel so that class room presentations have a more consistent behaviour
# did not really need -- commenting out for the moment
#RUN pip install jupyterthemes
# RUN pip install --upgrade jupyterthemes

# add support for nbstripout so that by default commits back to a book repo will strip out cell outputs
RUN pip install nbstripout

# not really happy with the existing themes but used them to hackup
# something that is ok for the moment
COPY custom /home/jovyan/.jupyter/custom

USER root
RUN chown -R jovyan /home/jovyan/.jupyter

# as per the nbstripout readme we setup nbstripout be always be used for the joyvan user for all repos
RUN nbstripout --install --system 

# as a hack we are going to try changing group id of /home/joyvan to be root to see if I can trick things into
# working on the moc
RUN chgrp -R root /home/jovyan
RUN chmod -R g+rX /home/jovyan

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

# jupyter-stack contains logic to run custom start hook scripts from
# two locations -- /usr/local/bin/start-notebook.d and
#                 /usr/local/bin/before-notebook.d
# and scripts in these directoreis are run automatically
# an opportunity to set things up based on dynamic facts such as user name
COPY start-notebook.d /usr/local/bin/start-notebook.d
