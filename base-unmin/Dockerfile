FROM jappavoo/bu-cs-book-dev-base:latest

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.
 
USER $NB_USER

# If you do switch to root, always be sure to add a "USER $NB_USER" command at the end of the
# file to ensure the image runs as a unprivileged user by default.

# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.

USER root
# turned off for the moment to minimize size
# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
RUN yes | unminimize || true

USER $NB_USER
