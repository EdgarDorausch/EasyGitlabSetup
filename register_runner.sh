#!/bin/bash

if [ -z "$GL_HOSTNAME" ];
  then echo "GL_HOSTNAME (environment variable) is not defined!";
  
  elif [ -z "$GL_CI_REG_TOKEN" ];
  then echo "GL_CI_REG_TOKEN (environment variable) is not defined! Please visit http://$GL_HOSTNAME/admin/runners to get the current registration token";
  
  # Register Gitlab Runner
  else sudo -E docker run \
    --rm -t -i \
    -v $(pwd)/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:3 \
    --url "http://$GL_HOSTNAME/" \
    --registration-token $GL_CI_REG_TOKEN \
    --description "docker-runner" \
    --run-untagged="true" \
    --locked="false";
fi

