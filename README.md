# Easy Gitlab Setup
This project provides a simple way to install gitlab + gitlab-ci/cd (continious-integration/continuous-delivery) via docker images. In order to run ci-tasks you need to connect a "runner" to gitlab (registering).

All local data will be stored in volumes mapped to `./gitlab` and `./gitlab-runner` on the host machine. (Additionally all backup-data will be stored in `./gitlab_backups`)

With this setup Gitlab uses the following ports:
* SSH: 1022
* HTTP: 1080

So you may have to adjust some config file (e.g. like it is describet in the [SSH Access](#SSH-Access) section of this README)

| WARNING: To address the docker containers they will be named `gitlab` or `gitlab-runner` respectively! So make sure that the names are not already in use |
| --- |

| WARNING: On the web interface the standard clone url is set `http://nicepype_gitlab/`. If you want to change the url follow [this](https://docs.gitlab.com/omnibus/settings/configuration.html#configuring-the-external-url-for-gitlab) steps and run the reconfigure script! |
| --- |



All scripts can display a help page by executing `<script> -h`
Follow the Setup section to get started.

## Setup
Run the following command:

```bash
source ./setup.sh
```
after the installation has finished¹. Visit your specified host (at port 1080) and sign-in as admin. Now register the gitlab-ci-runner²:
```bash
./register_runner.sh
```

After this step you can visit the gitlab web app at your specified host and set the admin password. Now you are able to log-in as admin (name: root) 

------
¹ You can display the container logs with `sudo docker logs gitlab -f`
² If yor registration token is not set correctly (e.g. by not running the setup script with source) you have to set it manually: visit `https://<host>/admin/runners` copy the token and pass it as an argument: `./register_runner -t <token>`.

## SSH Access
Since the gitlab ssh server runs on port 1022 one have to adjust the ssh configuration file. (user-scoped: `~/.ssh/config`; system-wide:`/etc/ssh/ssh_config`;
For more information run `man ssh_config`)

So you may have to add the following lines to the config file:
```
Host <name-in-the-url>
  Hostname <name-resolves-to>
  Post 1022
```

Because you may not want to establish every ssh connection to the specified host under port 1022 `Host` and `Hostname` should be different.

### Example
```
Host nicepype_gitlab
  Hostname jessie06
  Post 1022
```

This rule will only be used when one tries to connect to 
`git@nicepype_gitlab:<repository_path>.git`.
This will be resolved to a connection to jessie06 under port 1022.

## Reconfigure
If you want to change some configuration settings (e.g. in the gitlab.rb file) you have to reconfigure gitlab afterwards.
To do so run `./reconfigure.sh`
This will reconfigure and restart the gitlab server (which can take a few minutes)

## Uninstall
To remove gitlab simply run `./uninstall.sh`

## Backup

| WARNING: To restore a backup the `./gitlab/config/gitlab-secrets.json` file is needed since the database backup is encrypted. So it is  RECOMMENDED to store the configuration/secret files |
| --- |

### Create backup
To create a backup simply execute the `./create_backup.sh` script. (use the -n flag to not store configuration-files/secrets)

The backup files may be owned by the root user so you need super-user rights to view/restore them.

### Restore backup
To restore a backup run `./restore_backup.sh -f <backup_file_name>` (use the -n flag to not restore configuration-files/secrets)

## Interesting Settings
 - Runner-Dashboard: http://jessie06:1080/admin/runners
 - Visibility and access controls (default branch protection?, https access?, etc...): http://jessie06:1080/admin/application_settings
 - (Issue) Labels: http://jessie06:1080/admin/labels (newly created labels may be imported only for new projects, so one have to add them to the existing ones manually)

## Further reading for Gitlab:
- [Install gitlab runner in docker](https://docs.gitlab.com/runner/install/docker.html#docker-image-installation-and-configuration)
- [Run docker containers in gitlab-ci](https://docs.gitlab.com/ce/ci/docker/using_docker_images.html)
- [Gitlab pipeline configuration](https://docs.gitlab.com/ce/ci/yaml/README.html)
- [Gitlab backups](https://docs.gitlab.com/ee/raketasks/backup_restore.html)

## Some hints for debugging
- [Set localhost=host](https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach)
- [Docker-runner unable to pull](https://stackoverflow.com/questions/47695126/why-cant-gitlab-runner-clone-my-project-incorrect-hostname-failed-to-connect)