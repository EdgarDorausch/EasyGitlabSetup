#!/bin/bash

export FILENAME=$( sudo docker exec -t gitlab gitlab-rake gitlab:backup:create | grep -oP '(?<=Creating backup archive: ).*(?=\.tar)')
echo $FILENAME

sudo cp ./gitlab/config/gitlab.rb ./gitlab_backups/config/${FILENAME}_gitlab.rb
sudo cp ./gitlab/config/gitlab-secrets.json ./gitlab_backups/config/${FILENAME}_gitlab-secrets.json