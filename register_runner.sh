#!/bin/bash

# Check/set hostname
echo "GL_HOSTNAME is set to '${GL_HOSTNAME:=$(hostname)}'";

if [ -z "$GL_CI_REG_TOKEN" ];
  then echo "GL_CI_REG_TOKEN (environment variable) is not defined! Please visit http://$GL_HOSTNAME:1080/admin/runners to get the current registration token";
  
  echo "GL_HOSTNAME $GL_HOSTNAME"
  echo "GL_CI_REG_TOKEN $GL_CI_REG_TOKEN" 

  # Register Gitlab Runner
  else sudo -E docker run \
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

