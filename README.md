# UC Davis DAMS - Fin Deployment

## Deployment Overview

This repository stores the definition of the UC Davis DAMS fin deployment.

A fin application deployment is a series of Github repositories each containing docker containers for various fin services.  The docker containers will be built and tagged based on the defined repository tags/branchs (*see below for note on this) within [config.sh](./config.sh).

The following repositories are (currently) used to create the UC Davis Library DAMS deployment:

- [fin-server](https://github.com/UCDavisLibrary/fin-server)
  - `fin-fcrepo` Fedora common repository container
  - `fin-postgres` PostgresSQL with init scripts to be used with fcrepo
  - `fin-node-utils` Middleware image containing NodeJS utilities for microservices
  - `fin-server` Main Fin proxy server
  - `fin-trusted-proxy` Internal fin service which can be used for admin access to fcrepo by other services
- [fin-ucd-lib-server](https://github.com/UCDavisLibrary/fin-ucd-lib-server)
  - `fin-elasticsearch` Powers front end client search interface
  - `fin-ucd-lib-server` Extends `fin-server` adding transforms for essync, registers essync and ucd-lib-client services
  - `fin-essync` Service to synchronize changes from fcrepo to elastic search
  - `fin-ucd-lib-client` UC Davis DAMS front end client
- [fin-service-loris](https://github.com/UCDavisLibrary/fin-service-loris)
  - `fin-loris` IIIF Image service
- [fin-service-tesseract](https://github.com/UCDavisLibrary/fin-service-tesseract)
  - `fin-tesseract` Tesseract OCR service
- [fin-cas-service](https://github.com/UCDavisLibrary/fin-service-tesseract)
  - `fin-cas` CAS authentication service

Additionally this repository defines:

- `fin-ucd-lib-server-impl` Extends `fin-ucd-lib-server` registering IIIF, Tesseract and CAS services.  Adds fin env tags for all containers used in build.

*Note: When deploying to production always use respository version tags in deployment definition (config.sh).  However when deploying to development environments which change rapidly as bugs are fixed and features are added, it is ok to use branches in the deployments definition.  When branches are used and new images are built, the latest versions for these branches will be pulled for the build.  You can kick off dev builds with the ```submit.sh``` script to create images without changing the deployment definition.

## Creating New Deployment Images

To create a new deployment:

- First, make sure you have modified your code, commited to appropriate repository and added a new version tags to the repository.
- Update the ```config.sh``` file with the updated repository tags or branches.
- Update the main ```APP_VERSION``` number in ```config.sh```
- Run ```./templates/generate.sh``` to create a new ```docker-compose.yaml``` file with updated tags
- Commit your changes to this repo to GitHub
- Tag your commit with the same version number as `APP_VERSION` and push tag to Github
- Once a new tag is pushed to Github, Google Cloud Build will automatically create new images and push them to DockerHub

For development builds where you are using branches in the deployment definition, you can call ```submit.sh``` to kick off new builds.

## Running a Deployment

To run a fin application deployment:

- Pull this repository ```git clone https://github.com/UCDavisLibrary/fin-ucd-lib-deployment```
- Checkout tag for version of application you wish to run ```git checkout [tag]```
- Make sure you have a `.env` file in the root directory.  Here is a sample:

```bash
FIN_URL=https://sandbox.dams.library.ucdavis.edu
FIN_ENV=prod
CAS_URL=https://ssodev.ucdavis.edu/cas
JWT_ISSUER=library.ucdavis.edu
JWT_SECRET=[your secret]
```

To use elastic search in docker for windows, you must making the following edit using the Ubuntu Subsystem for Linux (WSL) terminal:
sudo sysctl -w vm.max_map_count=262144
vm.max_map_count = 262144

Note: To enable Google Cloud Logging you must add the mount path for `webapp-service-account.json` file.  If you place it in the root directory, add the following to your `.env` file:

```bash
GCLOUD_SERVICE_ACCOUNT_MOUNT=./webapp-service-account.json
```

- finally run ```docker-compose up -d``` in root directory

## Updating a Deployment

If you were already running a deployment and want to update the version of the application:

- ```docker-compose down``` Stop the application
- ```git checkout [tag]``` pull this repository to the desired application version
- ```docker-compose pull``` pull the new images
- ```docker-compose up -d``` start the application

## Verifing a Deployment

The ```fin-ucd-lib-server-impl``` will contain environment variables containing repository git hashes and tags used in the build.  Additionaly ```/fin/info``` will show you these same tags as a rest endpoint.

## Developing on Your Local Machine

### Local Development Overview

Working on code within docker containers can provide challanges.  The following setup is not required; you can build, stop and start fresh containers as you develop, though this process can be cumbersome and slow.  We will use the practice of mounting local filesystem volumes into containers so code changes are applied in real time.  Additionaly, if you server is being worked on and restarts are required for those changes to show, the following pattern is preferred. 

In the `fin-local-dev/docker-compose.yaml` file, set the services command to:

```yaml
command: bash -c 'tail -f /dev/null'
```

This will start the container up without running the default process.  Next start the cluster

```bash
cd fin-local-dev
docker-compose up -d
```

Finally, open a tty connection running bash to the container and start the server from within the container

```bash
docker-compose exec ucd-lib-client bash
node /server
```

No if you want to restart the server, you can simply type `Ctrl+C` to kill the server and then run `node /server` again without having to restart the entire container.

## Local Development Setup

First, clone this repository to your local disk and checkout the version/tag you want to work from.

You can generate a new development docker-compose.yaml script via `./templates/generate.sh`.  This will create a new docker-compose.yaml in `/fin-local-dev`.  Note, git ignores this yaml file so you can make local changes that won't effect other developers, those these changes will be wiped each time your run `./templates/generate.sh`.

You will need to create a `.env` file in the `/fin-local-dev` directory, here is a sample:

```.env
JWT_SECRET=[your secret here]
JWT_ISSUER=library.ucdavis.edu
JWT_TTL=86400
JWT_VERBOSE=false
FIN_URL=http://localhost:3000
```

Now, create the repositories folder inside `fin-local-dev`

```bash
mkdir fin-local-dev/repositories
```

Somewhere on disk checkout the all repositories required for this deployment for Fin.  As of this writing there are five, check `config.sh` for required repositories.  Make sure you check each out the correct branch for each repository.  Note, this part is not automated as we do not want to accidently remove any changes you may have made.  It is up to you the developer to ensure your development repositories are at the same branch/tag as this deployment.

```bash
git clone https://github.com/UCDavisLibrary/fin-server
git clone https://github.com/UCDavisLibrary/fin-ucd-lib-server
# ...
```

Then you want to create symbolic links to each repository from the `fin-local-dev/repositories` directory.

```bash
cd fin-local-dev/repositories
ln -s ../../fin-server .
ln -s ../../fin-ucd-lib-server .
# ...
```

Finally, create the `:local-dev` tagged images used by the `fin-local-dev/docker-compose.yaml` file.

```bash
./fin-local-dev/build.sh
```

This build script uses Docker BUILDKIT which should make subsequent builds very fast.  You should never push these local-dev images to Docker Hub.

## Run Local Development

After completing the local development setup, simply:

```bash
cd fin-local-dev
docker-compose up
```
