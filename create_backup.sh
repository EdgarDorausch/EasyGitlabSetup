#!/bin/bash

usage() {
  echo -n "
This script creates a backup for gitlab. All backup data is stored in the gitlab_backups directory.
(The subdirectories storing the following content: data -> all git data; config -> configuration files+secrets of gitlab)

 Options:
  -n      No Config: Gitlab configuration/secrets is not stored
  -h      Display this help and exit
"
}

CONFIG_FLAG=true

# --- Options processing -------------------------------------------

while getopts ":hn" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "n") CONFIG_FLAG=false;;
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

# Create directories
mkdir -p "$CONFIG_PATH"
mkdir -p "$DATA_PATH"

echo "========= CREATE BACKUP ========="
OUTPUT=$( sudo docker exec -t gitlab gitlab-rake gitlab:backup:create )
FILENAME=$( echo "$OUTPUT" | grep -oP '(?<=Creating backup archive: ).*(?=\.tar)')
echo "$OUTPUT"
echo "Backup stored under $DATA_PATH$FILENAME.tar"

if $CONFIG_FLAG; then
  echo "========= STORE CONFIG DATA ========="


  sudo cp ./gitlab/config/gitlab.rb ${CONFIG_PATH}${FILENAME}_gitlab.rb
  echo "Backup stored under $CONFIG_PATH${FILENAME}_gitlab.rb"

  sudo cp ./gitlab/config/gitlab-secrets.json ${CONFIG_PATH}${FILENAME}_gitlab-secrets.json
  echo "Backup stored under $CONFIG_PATH${FILENAME}_gitlab-secrets.json"

fi
####################################################
############### End Script Here ####################
