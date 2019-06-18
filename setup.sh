#!/bin/bash

usage() {
  echo -n "
This script spins up two docker containers. One for gitlab-ce and for the gitlab runner.
(Run \`source ./setup\` to store the registration token automatic automatically in an environment variable for the regestration script)

 Options:
  -n      HostName (defaults to \$hostname if not set)
  -h      Display this help and exit
"
}

# --- Options processing -------------------------------------------

while getopts ":hn:" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "n") GL_HOSTNAME=$OPTARG;;
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

# Check/set hostname
echo "Hostname: ${GL_HOSTNAME:=$(hostname)}";

# Generate random token
export GL_CI_REG_TOKEN=`date +%s|sha256sum|base64|head -c 32`;
echo "Registration token: $GL_CI_REG_TOKEN";

# Start docker containers
echo "Setup docker:"
echo "Run gitlab-ce image"
echo "============"

NL=$'\n'

# Configuration:
# Custom backup path
GL_BACKUP_PATH="gitlab_rails['backup_path']=\"/var/gitlab_backups\""
# Set clone url to nicepype_gitlab
GL_EXTERNAL_URL="external_url \"http://nicepype_gitlab\""

#install gitlab-ce
sudo -E docker run --detach \
  -e GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=$GL_CI_REG_TOKEN \
  --hostname $GL_HOSTNAME \
  --publish 1443:443 --publish 1080:80 --publish 1022:22 \
  --name gitlab \
  --restart always \
  --env GITLAB_OMNIBUS_CONFIG="$GL_BACKUP_PATH $NL $GL_EXTERNAL_URL" \
  --volume $(pwd)/gitlab/config:/etc/gitlab \
  --volume $(pwd)/gitlab/logs:/var/log/gitlab \
  --volume $(pwd)/gitlab/data:/var/opt/gitlab \
  --volume $(pwd)/gitlab_backups/data:/var/gitlab_backups \
  gitlab/gitlab-ce:latest

echo "============"
echo "Run gitlab-runner image"
echo "============"

sudo -E ./start_runner.sh

echo "============"
