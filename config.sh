#! /bin/bash

######### MAIN CONFIG ##########
# Setup your application deployment here
################################

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v1.3.2

CORE_SERVER_REPO_TAG=deployment
UCD_LIB_SERVER_REPO_TAG=bag-of-files
LORIS_SERVICE_REPO_TAG=v1.0.0
TESSERACT_SERVICE_REPO_TAG=v1.0.1
CAS_SERVICE_REPO_TAG=v1.0.1

#### End main config ####


# Repositories
GITHUB_ORG_URL=https://github.com/UCDavisLibrary

## Core Server
CORE_SERVER_REPO_NAME=fin-server
CORE_SERVER_REPO_URL=$GITHUB_ORG_URL/$CORE_SERVER_REPO_NAME

## UCD Library Server
UCD_LIB_SERVER_REPO_NAME=fin-ucd-lib-server
UCD_LIB_SERVER_REPO_URL=$GITHUB_ORG_URL/$UCD_LIB_SERVER_REPO_NAME

## Loris Service
LORIS_SERVICE_REPO_NAME=fin-service-loris
LORIS_SERVICE_REPO_URL=$GITHUB_ORG_URL/$LORIS_SERVICE_REPO_NAME

## Tesseract Service
TESSERACT_SERVICE_REPO_NAME=fin-service-tesseract
TESSERACT_SERVICE_REPO_URL=$GITHUB_ORG_URL/$TESSERACT_SERVICE_REPO_NAME

## CAS Service
CAS_SERVICE_REPO_NAME=fin-service-cas
CAS_SERVICE_REPO_URL=$GITHUB_ORG_URL/$CAS_SERVICE_REPO_NAME

# Docker Hub
UCD_LIB_DOCKER_ORG=ucdlib
DOCKER_CACHE_TAG="latest-build"

# Docker Images
FCREPO_IMAGE_NAME=fin-fcrepo
POSTGRES_IMAGE_NAME=fin-postgres
NODE_UTILS_IMAGE_NAME=fin-node-utils
SERVER_IMAGE_NAME=fin-server
TRUSTED_PROXY_IMAGE_NAME=fin-trusted-proxy
ELASTIC_SEARCH_IMAGE_NAME=fin-elasticsearch
UCD_LIB_SERVER_IMAGE_NAME=fin-ucd-lib-server
ESSYNC_IMAGE_NAME=fin-essync
UCD_LIB_CLIENT_IMAGE_NAME=fin-ucd-lib-client
LORIS_IMAGE_NAME=fin-loris
TESSERACT_IMAGE_NAME=fin-tesseract
CAS_IMAGE_NAME=fin-cas
UCD_LIB_SERVER_IMPL=fin-ucd-lib-server-impl


# Git
GIT=git
GIT_CLONE="$GIT clone"

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories