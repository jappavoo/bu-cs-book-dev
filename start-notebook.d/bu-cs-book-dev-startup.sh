#!/bin/bash
#set -x
SN=bu-cs-book-dev-startup.sh
[[ -z $MOUNT_DIR ]] && export MOUNT_DIR=/opt/app-root/src

# this script is designed to be run by the jupyter stack /usr/local/bin/start.sh
echo "$SN: BEGIN: $(id -a)"

if [[ -d $MOUNT_DIR ]]; then
    echo "$SN: Found $MOUNT_DIR"
    FILE=.gitconfig
    echo "$SN: Mapping $FILE to $MOUNT_DIR/$FILE"
    if [[ ! -a $HOME/$FILE ]]; then
	if [[ ! -a $MOUNT_DIR/$FILE ]]; then
	    echo "$SN: creating $MOUNT_DIR/$FILE"
	    touch $MOUNT_DIR/$FILE
	fi
	if [[ -a $MOUNT_DIR/$FILE ]]; then
	    echo "$SN: Linking $MOUNT_DIR/$FILE -> $HOME/$FILE"
	    ln -s $MOUNT_DIR/$FILE $HOME/$FILE
	fi
    fi
    DIR=.ssh
    echo "$SN: Mapping $FILE to $MOUNT_DIR/$FILE"
    if [[ ! -d $HOME/$DIR ]]; then
	if [[ ! -d $MOUNT_DIR/$DIR ]]; then
	    echo "$SN: creating $MOUNT_DIR/$DIR"
	    if mkdir $MOUNT_DIR/$DIR; then
		if [[ $DIR == .ssh ]]; then
		    echo "$SN: Fixing permisions for $MOUNT/$DIR"
		    chmod 700 $MOUNT_DIR/$DIR
		fi
	    fi
	fi
	if [[ -d $MOUNT_DIR/$DIR ]]; then
	    echo "$SN: Linking $MOUNT_DIR/$DIR -> $HOME/$DIR"
	    ln -s $MOUNT_DIR/$DIR $HOME/$DIR	    
	    if [[ $DIR = .ssh ]]; then
		# As per the standard jupyter startup scripts we use the following test to
		# figure out if we have been started in a jupyterhub env
		if [[ -n "${JUPYTERHUB_API_TOKEN}" ]]; then
		    # during jupyter stacks startup logic "fixes permissions" on home directories
		    # this causes group permissions to be set.  We undo this with a hammer on .ssh
 		    echo "$SN: Fixing permissions in  $HOME/$DIR"
		    chmod -R go-rwxs $HOME/$DIR
	        fi
	    fi
	fi
    fi
    
    if [[ ! -L $HOME/.jupyter/lab && -a $MOUNT_DIR ]]; then
	if [[ ! -a $MOUNT_DIR/jupyter/lab ]]; then
            mkdir -p $MOUNT_DIR/jupyter/lab
	fi
	[[ -a $HOME/.jupyter/lab ]] && mv $HOME/.jupyter/lab $HOME/.jupyter/lab.old
	echo "$SN: linking: ln -s /opt/app-root/src/jupyter/lab ~/.jupyter/lab"
	ln -s $MOUNT_DIR/jupyter/lab $HOME/.jupyter/lab
    fi

    if [[ -a $MOUNT_DIR/.myjupyter_start.sh ]]; then
	echo "$SN: Found $MOUNT_DIR/.myjupyter_start.sh: sourcing it"
	. $MOUNT_DIR/.myjupyter_start.sh
    fi
fi

# When running on JupyterHub we are forcing to start with classic notebook (we don't do these overrides if
# you are running the container locally):
# To ensure that classic mode relative path urls resolve correctly... this is not true if we
# start lab first and then use the notebook interface.  However, if we start classic and then
# relatives paths resolve correctly in both lab and classic notebook interfaces
if [[ -n "${JUPYTERHUB_API_TOKEN}" ]]; then
     if [[ "${cmd[1]}" == "lab" ]]; then
	 cmd[1]=notebook
	 echo "$SN: over riding : lab to notebook: ${cmd[@]}"
     elif [[ ${cmd[1]} != "notebook" ]]; then
	 # lab and notebook have not been specified
	 # insert notebook so that default is overridden
	 cmd=("${cmd[@]:0:1}" "notebook" "${cmd[@]:1}")
	 echo "$SN: forcing : notebook: ${cmd[@]}"
     fi
fi
echo "$SN: ${cmd[@]}: ${cmd[1]}"
echo "$0: END"
