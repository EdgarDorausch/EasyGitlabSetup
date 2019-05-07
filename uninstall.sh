#!/bin/bash
 
read -r -p "Are You Sure? [Yes/n] " input
 
case $input in 
  [Y][e][s])
    echo "Uninstall gitlab...";
    sudo docker stop gitlab;
    sudo docker stop gitlab-runner;

    sudo docker rm gitlab;
    sudo docker rm gitlab-runner;

    # sudo docker rmi gitlab/gitlab-ce:latest;
    # sudo docker rmi gitlab/gitlab-runner:latest;

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
