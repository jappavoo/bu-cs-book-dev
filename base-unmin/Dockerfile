FROM jappavoo/bu-cs-book-dev-base:latest

USER root

# turned off for the moment to minimize size
# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
RUN yes | unminimize || true

USER $NB_USER
