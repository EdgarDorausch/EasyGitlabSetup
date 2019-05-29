#!/bin/bash

usage() {
  echo -n "
This script restarts the gitlab-ce and gitlab-runner docker images

 Options:
  -h      Display this help and exit
"
}

# --- Options processing -------------------------------------------

while getopts ":h" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done


############## Begin Script Here ###################
####################################################

sudo docker start gitlab
sudo docker start gitlab-runner