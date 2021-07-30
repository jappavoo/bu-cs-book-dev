#!/bin/bash
#set -x
SN=bu-cs-book-dev-startup.sh
# this script is designed to be run by the jupyter stack /usr/local/bin/start.sh
# As per the standard jupyter startup scripts we use the following test to
# figure out if we have been started in a jupyterhub env
echo "$SN: BEGIN: $(id -a)"

if [[ -n $JUPYTERHUB_USER_NAME ]]; then
    # see if we need to create links to permenant stored verions of critical files
    # .gitconfig
    # .ssh
    # emacs and vim config
    # gdb 

    # once the above is done we can get rid of this
    echo "$SN: configuring git user email to $JUPYTERHUB_USER_NAME"
    git config --global user.email "$JUPYTERHUB_USER_NAME"
    echo "$SN: configuring git user name to ${JUPYTERHUB_USER_NAME%%@*}"
    git config --global user.name "${JUPYTERHUB_USER_NAME%%@*}"
fi

echo "$0: END"
