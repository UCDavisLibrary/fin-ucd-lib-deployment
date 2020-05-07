

# Overview

This repository stores the definition of the UC Davis DAMS fin deployment.

A fin application deployment is a series of Github repositories each containing 
docker containers.  The docker containers will be built and tagged based on
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
    - `fin-essync-service` Service to synchronize changes from fcrepo to elastic search
    - `fin-ucd-lib-client` UC Davis DAMS front end client
  - [fin-service-loris](https://github.com/UCDavisLibrary/fin-service-loris)
    - `fin-loris-service` IIIF Image service
  - [fin-service-tesseract](https://github.com/UCDavisLibrary/fin-service-tesseract)
    - `fin-tesseract-service` Tesseract OCR service
  - [fin-cas-service](https://github.com/UCDavisLibrary/fin-service-tesseract)
    - `fin-cas-service` CAS authentication service

Additionally this repository defines:
  - `fin-ucd-lib-server-impl` Extends `fin-ucd-lib-server` registering IIIF, Tesseract and CAS services.  Adds fin env tags for all containers used in build.

*Note: When deploying to production always use respository version tags in deployment definition (config.sh).  However when deploying to development environments which change rapidly as bugs are fixed and features are added, it is ok to used branches in the deployments definition.  When branches are used and new images are built, the latest versions for these branches will be pulled for the build.  You can kick off dev builds with the ```submit.sh``` script to create images without changing the deployment definition.

# Creating New Deployment Images

To create a new deployment:
  - First, make sure you have modified your code, commited to appropriate repository and added a new version tags to the repository.
  - Update the ```config.sh``` file with the updated repository tags or branches. 
  - Update the main ```APP_VERSION``` number in ```config.sh```
  - Run ```./generate.sh``` to create a new ```docker-compose.yaml``` file with updated tags
  - Commit your changes to this repo to GitHub
  - Tag your commit with the same version number as `APP_VERSION` and push tag to Github
  - Once a new tag is pushed to Github Google Cloud Build will automatically create new images and push them to DockerHub

For development builds where you are using branches in the deployment definition, you can call ```submit.sh`` to kick off new builds.

# Running a Deployment

To run a fin application deployment:
  - Pull this repository ```git clone https://github.com/UCDavisLibrary/fin-ucd-lib-deployment```
  - Checkout tag for version of application you wish to run ```git checkout [tag]```
  - run ```docker-compose up -d``` in root directory
    - Note: many of the containers require a `webapp-service-account.json` to exist in the root directory.

If you were already running a deployment make sure and
  - ```docker-compose down``` Stop the application
  - ```git checkout [tag]``` pull this repository to the desired application version
  - ```docker-compose pull``` pull the new images
  - ```docker-compose up -d``` start the application

# Verifing a Deployment

The ```fin-ucd-lib-server-impl``` will contain environment variables containing repository git hashes and tags used in the build.  Additionaly ```/fin/info``` will show you these same tags as a rest endpoint.

# Developing on your local machine

WIP