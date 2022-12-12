

# UC Davis DAMS - Fin Deployment

## Deployment Overview

This repository stores the definition of the UC Davis DAMS fin deployment.

A fin application deployment is a series of Github repositories each containing 
docker containers for various fin services.  The docker containers will be built and tagged based on
the defined repository tags/branchs (*see below for note on this) within [config.sh](./config.sh).

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

For development builds where you are using branches in the deployment definition, you can call ```submit.sh`` to kick off new builds.

## Running a Deployment

To run a fin application deployment:
  - Pull this repository ```git clone https://github.com/UCDavisLibrary/fin-ucd-lib-deployment```
  - Checkout tag for version of application you wish to run ```git checkout [tag]```
  - Make sure you have a `.env` file in the root directory.  Here is a sample:

```
FIN_URL=https://sandbox.dams.library.ucdavis.edu
FIN_ENV=prod
CAS_URL=https://ssodev.ucdavis.edu/cas
JWT_ISSUER=library.ucdavis.edu
JWT_SECRET=[your secret]
```

Note: To enable Google Cloud Logging you must add the mount path for `webapp-service-account.json` file.  If you place it in the root directory, add the following to your `.env` file:

```
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

# Developing on Your Local Machine

When running applications locally, we follow a few best practices to make development easier/smoother. Read the [Local Development](https://docs.google.com/document/d/1_apSpfNdpbXeIE-eGSJ3EpZr-S1SE3L0l0TBirZWrds/edit#heading=h.r0k0nn238ncf) section in the UC Davis Library developers guide before proceeding.

## Cloning Code and Building Images

First, make a directory for this project on your local disk, enter it, and clone this repository. Checkout the version/branch/tag you want to work from.

Next, retrieve all the additional repositories needed to run this application. In the project directory (not this repo), clone all repositories listed in the `ALL_GIT_REPOSITORIES` variable in `config.sh`. Make sure that each repository is on the branch you want. It is up to you the developer to ensure your development repositories are at the same branch/tag as this deployment. Next, in this repository, link these repositories with `./cmds/init-local-dev.sh`.

Create Keycloak config files and generate a docker compose file for local development by running:
```bash
npm install -g @ucd-lib/cork-template
./cmds/update-local-dev-keycloak.sh
./cmds/generate-deployment-files.sh
```
This will create a new docker-compose.yaml in `/fin-local-dev`.  Note, git ignores this yaml file so you can make local changes that won't affect other developers, any changes will be wiped each time your run `./cmds/generate-deployment-files.sh`.

Then rebuild the docker images with `./cmds/build-local-dev.sh`.

You will need to create a `.env` file in the `/fin-local-dev` directory, here is a sample:

```.env
JWT_SECRET=librariesaregreat
JWT_ISSUER=library.ucdavis.edu
JWT_TTL=86400
JWT_VERBOSE=false
FIN_URL=http://localhost:3000
CAS_URL=https://ssodev.ucdavis.edu/cas

OIDC_CLIENT_ID=dams-local-dev
OIDC_BASE_URL=https://keycloak:8443/realms/dams-local-dev
OIDC_SECRET=xxxxx
DATA_ENV=sandbox
JWT_JWKS_URI=http://keycloak:8080/realms/dams-local-dev/protocol/openid-connect/certs
```

Finally, create the `:local-dev` tagged images used by the `fin-local-dev/docker-compose.yaml` file with `./cmds/build-local-dev.sh`. You should never push these local-dev images to Docker Hub.

## Client Dependencies and Build

The client is a single page application that we want to update everytime a code change is made. From the fin-server repo run:

```bash
cd services/fin/ucd-lib-client/client/public/
npm install
```

Start the watch process with
```bash
cd services/fin
npm run client-watch
```

## Running Your Cluster

After completing the local development setup, simply:

```bash
cd fin-local-dev
docker-compose up
```

## Hydrating The Application

Now, we need some example data for our application, which requires the fin cli:

From the fin-server repository, run
```bash
cd fin-api/
npm install && npm link
fin config set host http://localhost:8080
```

Next, from the project directory, download the data and import:

```bash
git clone https://github.com/UCDavisLibrary/fin-example-repository.git
cd fin-example-repository
git checkout <whatever you are working on>
cd collection/ex1-pets
FCREPO_DIRECT_ACCESS=true FCREPO_SUPERUSER=true fin io import ex1-pets .
```

## Administering Keycloak

Navigate to `http://localhost:8081/` to access the admin console. Change from the `Master` realm to the `dams-local-dev` realm.

Clients are the applications/services that can request authentication from a user. In this case, the `dams-local-dev` client has the application config for DAMS. Under `Users` you can add users and roles for users. However you shouldn't need to create a user manually, instead navigating to `http://localhost:3000/auth/keycloak-oidc/login` should prompt for the CAS login, and your user will be created automatically. You can come to the admin console after to add the admin role to the user.
