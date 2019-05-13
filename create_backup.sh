#!/bin/bash

usage() {
  echo -n "
This script creates a backup for gitlab. All backup data is stored in the gitlab_backups directory.
(The subdirectories storing the following content: data -> all git data; config -> configuration files+secrets of gitlab)

 Options:
  -c      Saves gitlab configuration/secrets too
  -h      Display this help and exit
"
}

config_flag=false

# --- Options processing -------------------------------------------

while getopts ":hc" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "c") config_flag=true;;
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

CONFIG_PATH="./gitlab_backups/config/"
DATA_PATH="./gitlab_backups/data/"

echo "========= CREATE BACKUP ========="
export FILENAME=$( sudo docker exec -t gitlab gitlab-rake gitlab:backup:create | grep -oP '(?<=Creating backup archive: ).*(?=\.tar)')
echo "Backup stored under $DATA_PATH$FILENAME.tar"

if $config_flag; then
  echo "========= STORE CONFIG DATA ========="


  sudo cp ./gitlab/config/gitlab.rb ${CONFIG_PATH}${FILENAME}_gitlab.rb
  echo "Backup stored under $CONFIG_PATH${FILENAME}_gitlab.rb"

  sudo cp ./gitlab/config/gitlab-secrets.json ${CONFIG_PATH}${FILENAME}_gitlab-secrets.json
  echo "Backup stored under $CONFIG_PATH${FILENAME}_gitlab-secrets.json"

fi
####################################################
############### End Script Here ####################
