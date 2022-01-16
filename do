iface=$1

[[ -z $iface ]] && iface=lab

make MOUNT_DIR=/home/jovyan/work $iface
