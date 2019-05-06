#!/bin/bash

export GL_HOSTNAME=$(hostname)

if [ -z "$GL_HOSTNAME" ];
  then echo "GL_HOSTNAME (environment variable) is not defined!";
  else
    echo "GL_HOSTNAME is set to '$GL_HOSTNAME'";
    
    # Generate random token
    export GL_CI_REG_TOKEN=`date +%s|sha256sum|base64|head -c 32`;
    echo "New ci-token generated!";

    echo "Setup docker:"
    echo "Run gitlab-ce image"
    echo "============"
    
    # install gitlab-ce
    sudo -E docker run --detach \
      -e GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=$GL_CI_REG_TOKEN \
      --hostname $GL_HOSTNAME \
      --publish 1443:443 --publish 1080:80 --publish 1022:22 \
      --name gitlab \
      --restart always \
      --volume /gitlab/config:/etc/gitlab \
      --volume $(pwd)/gitlab/logs:/var/log/gitlab \
      --volume $(pwd)/gitlab/data:/var/opt/gitlab \
      gitlab/gitlab-ce:latest

    echo "============"
    echo "Run gitlab-runner image"
    echo "============"

    sudo -E docker run -d --name gitlab-runner --restart always \
      -v $(pwd)/gitlab-runner/config:/etc/gitlab-runner \
      -v /var/run/docker.sock:/var/run/docker.sock \
      gitlab/gitlab-runner:latest

    echo "============"

fi
