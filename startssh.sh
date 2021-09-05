#/bin/bash
keyfile=${1:-~/.ssh/id_rsa.pub}
user=jovyan
port=2222 

if [[ ! -a $keyfile ]]; then
   echo "No keyfile: $keyfile"
   keyfile=""
fi

docker ps 
read -p "Enter Container id: " id

docker exec -u 0  $id /bin/bash -c 'echo -e "AddressFamily inet\nStrictModes no" >> /etc/ssh/sshd_config'

if [[ -n $keyfile ]]; then
    docker exec  $id /bin/bash -c "mkdir /home/$user/.ssh"
    docker exec -i $id /bin/bash -c "cat > /home/$user/.ssh/authorized_keys" < $keyfile 
fi

docker exec -u 0 -it $id service ssh stop
docker exec -u 0 -it $id service ssh start

echo "This should now work:"

echo "ssh -p $port -i ${keyfile%%.pub} $user@localhost"
echo "ssh -p $port -i ${keyfile%%.pub} $user@localhost xterm"
echo "ssh -p $port -i ${keyfile%%.pub} $user@localhost inkscape"

