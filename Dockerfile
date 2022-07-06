ARG VERSION
ARG BASE_IMAGE
#FROM quay.io/rh_ee_adhayala/bu-cs-book-dev-fedora-base-unmin:latest
FROM ${BASE_IMAGE}:${VERSION}
#FROM rh_ee_adhayala/bu-cs-book-dev-fedora-base:${VERSION}
 
USER 1001

# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.

# Add RISE 5.4.1 to the mix as well so user can show live slideshows from their notebooks
# More info at https://rise.readthedocs.io
# Note: Installing RISE with --no-deps because all the neeeded deps are already present.
# Add Bash kernel
# Add jupyter-book development support
# Add ghp-import so that we can publish books to github easily
# Add jupytext, nbgitpuller - As per jupyter book instructions for interactive support
# ipywidgets not sure if this is already included but install
# added matplotlib, pands, plotly_express
# enable classic notebook nbextensions


RUN pip install --no-dependencies rise && pip install bash_kernel jupyter-book ghp-import \
    jupytext nbgitpuller widgetsnbextension ipywidgets matplotlib anaconda pandas plotly \
    plotly_express jupyter_contrib_nbextensions


# turn on spellchecker extension
# enable split cell, hide-all, hide, python-markdown/main - enable the use of python in markdown cells
RUN jupyter nbextension enable spellchecker/main \
    && jupyter nbextension enable splitcell/splitcell \
    && jupyter nbextension enable hide_input_all/main \
    && jupyter nbextension enable hide_input/main \
    && jupyter nbextension enable python-markdown/main



# customize look and feel so that class room presentations have a more consistent behaviour
# did not really need -- commenting out for the moment
# add support for nbstripout so that by default commits back to a book repo will strip out cell outputs
#RUN pip install jupyterthemes
RUN pip install --upgrade jupyterthemes nbstripout 

