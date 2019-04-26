#!/bin/bash

if [ -z "$GL_HOSTNAME" ];
  then echo "GL_HOSTNAME (environment variable) is not defined!";
  else
    echo "GL_HOSTNAME is set to '$GL_HOSTNAME'";
    
    # Generate random token
    export GL_CI_REG_TOKEN=`date +%s|sha256sum|base64|head -c 32`;
    echo "New ci-token generated!";

    # Start docker-compose
    echo "Setup docker:"
    echo "============"
    sudo -E docker-compose up -d --build;
    echo "============"
fi



