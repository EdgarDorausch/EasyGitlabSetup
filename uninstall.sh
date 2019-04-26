#!/bin/bash
 
read -r -p "Are You Sure? [Yes/n] " input
 
case $input in 
  [Y][e][s])
    echo "Uninstall gitlab...";
    sudo docker-compose stop;
    sudo docker-compose rm;
    sudo rm -r ./gitlab ./gitlab-runner;
  ;;
  [n])
    echo "Abort..."
  ;;
  *)
    echo "Invalid input..."
    exit 1
  ;;
esac