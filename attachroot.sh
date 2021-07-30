#/bin/bash
docker ps 
read -p "Enter Container id: " id
docker exec -u 0 -it $id /bin/bash
