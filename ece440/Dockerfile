FROM quay.io/jappavoo/bu-cs-book-dev:latest

USER root 
RUN apt-get update && apt-get install -y valgrind libasan5 libubsan1

USER $NB_USER
