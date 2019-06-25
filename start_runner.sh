sudo -E docker run -d --name gitlab-runner --restart always \
  -v $(pwd)/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:v11.11.2