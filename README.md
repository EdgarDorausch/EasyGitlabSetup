# Easy Gitlab Setup
This project provides a simple way to install gitlab + gitlab-ci/cd via docker images. All local data will be stored in volumes mapped to `./gitlab` and `./gitlab-runner` on the host machine.
Follow the Setup section to get started.

## Setup
Define your hostname as environment variable:
```bash
export GL_HOSTNAME=<name>
```
Run the following command:

```bash
source ./setup.sh
```
after the installation has finished¹. Visit your specified host (at port 80) and sign-in as admin. Now register the gitlab-ci-runner²:
```bash
./register_runner.sh
```

After this you can visit the gitlab web app at your specified host and set the admin password. Now you are able to log-in as admin (name: root) 

------
¹ You can display the container logs with `sudo docker logs gitlab -f`
² If yor registration token is not set correctly (e.g. by not running the setup script with source) you have to set it manually: visit `https://<host>/admin/runners` copy the token and add it as environment variable with `export GL_CI_REG_TOKEN=<token>`.

#### Further steps
The following steps should be done to finish the setup and adjust gitlab to your personal needs:

* Add (global) labels
* Create group(s)
* Create repos
* Add ci configuration

## Uninstall
To remove gitlab simply run `./uninstall.sh`

## Further reading for Gitlab:
- [Install gitlab runner in docker](https://docs.gitlab.com/runner/install/docker.html#docker-image-installation-and-configuration)
- [Run docker containers in gitlab-ci](https://docs.gitlab.com/ce/ci/docker/using_docker_images.html)
- [Gitlab pipeline configuration](https://docs.gitlab.com/ce/ci/yaml/README.html)

## Some hints for debugging
- [Set localhost=host](https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach)
- [Docker-runner unable to pull](https://stackoverflow.com/questions/47695126/why-cant-gitlab-runner-clone-my-project-incorrect-hostname-failed-to-connect)