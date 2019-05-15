#!/bin/bash

usage() {
  echo -n "
This script connects the gitlab runner so its possible to runn ci pipelines on this runner

 Options:
  -t      Set custom registration token
  -n      HostName (defaults to \$hostname if not set)
  -h      Display this help and exit
"
}

# --- Options processing -------------------------------------------

while getopts ":ht:n:" optname
  do
    case "$optname" in
      "h") usage; exit 0;;
      "n") GL_HOSTNAME=$OPTARG;;
      "t") GL_CI_REG_TOKEN=$OPTARG;;
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

if [ -z "$GL_CI_REG_TOKEN" ];
  then echo -n "
Registration token is not defined! Please visit http://$GL_HOSTNAME:1080/admin/runners to get the current registration token.
Set token with \`./register_runner -t <TOKEN>\`
";

  # Register Gitlab Runner
  else echo "Registration token: $GL_CI_REG_TOKEN";
    sudo -E docker run \
    --rm -t -i \
    -v $(pwd)/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:3 \
    --url "http://$GL_HOSTNAME:1080/" \
    --registration-token $GL_CI_REG_TOKEN \
    --description "docker-runner" \
    --run-untagged="true" \
    --locked="false";
fi
