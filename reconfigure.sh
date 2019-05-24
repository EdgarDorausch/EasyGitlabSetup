#!/bin/bash

read -r -p "Are You Sure? [Yes/n] " input
 
case $input in 
  [Y][e][s])
    sudo docker exec -it gitlab gitlab-ctl reconfigure
    sudo docker exec -it gitlab gitlab-ctl restart
  ;;
  [n])
    echo "Abort..."
  ;;
  *)
    echo "Invalid input..."
    exit 1
  ;;
esac