#!/bin/bash

usage() {
  echo -n "
This script restores a backup for gitlab. All backup data is stored in the gitlab_backups directory.
(The subdirectories storing the following content: data -> all git data; config -> configuration files+secrets of gitlab)

 Options:
  -f      Name of backup file. e.g.`1558102714_2019_05_17_11.10.4_gitlab_backup.tar`
  -n      No Config: Gitlab configuration/secrets will not be restored
  -h      Display this help and exit
"
}

FILE_NAME=""
RESTORE_CONFIG=true

# --- Options processing -------------------------------------------

while getopts ":hnf:" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "n") RESTORE_CONFIG=false;;
      "f") FILE_NAME=$OPTARG;;
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

CONFIG_BASE_PATH="./gitlab_backups/config/"
DATA_BASE_PATH="./gitlab_backups/data/"

# Check if filename passed as argument
if [ -z "$FILE_NAME" ]; then
  echo "[ERROR] Please set filename (./restore_backup -f <filename>)"
  exit 1
else
  BACKUP_BASE_NAME=$(echo "$FILE_NAME" | grep -oP '.*(?=_gitlab_backup\.tar)')

  # Check if BACKUP_BASE_NAME is not empty
  if [ -z "$BACKUP_BASE_NAME" ]; then
    echo "[ERROR] \`$FILE_NAME\` has not the right backup file format! (*_gitlab_backup.tar)"
    exit 1
  fi

  # echo "$BACKUP_BASE_NAME"

  # Define path to the relevant files
  CONFIG_FILE="${CONFIG_BASE_PATH}${BACKUP_BASE_NAME}_gitlab_backup_gitlab.rb"
  SECRETS_FILE="${CONFIG_BASE_PATH}${BACKUP_BASE_NAME}_gitlab_backup_gitlab-secrets.json"
  BACKUP_FILE="${DATA_BASE_PATH}${BACKUP_BASE_NAME}_gitlab_backup.tar"

  # Check if the files are existing
  if ! sudo [ -f "$CONFIG_FILE" ] && $RESTORE_CONFIG; then
    echo "[ERROR] Config file does not exist! ($CONFIG_FILE)"
    exit 1
  fi
  if ! sudo test -f "$SECRETS_FILE" && $RESTORE_CONFIG; then
    echo "[ERROR] Secrets file does not exist! ($SECRETS_FILE)"
    exit 1
  fi
  if ! sudo test -f "$SECRETS_FILE"; then
    echo "[ERROR] Backup file does not exist! ($BACKUP_FILE)"
    exit 1
  fi

  # Copy config files
  echo ">>>> Copy config files..."
  sudo cp $CONFIG_FILE ./gitlab/config
  sudo cp $SECRETS_FILE ./gitlab/config
  echo "Done!"

  # Restore backup 
  echo ">>>> Restore backup..."
  sudo docker exec -it gitlab gitlab-rake gitlab:backup:restore BACKUP=$BACKUP_BASE_NAME
  echo "Done!"

fi