#! /bin/bash

######### MAIN CONFIG ##########
# Setup your application deployment here
################################

# Grab build number is mounted in CI system
if [[ -f /config/.buildenv ]]; then
  source /config/.buildenv
else
  BUILD_NUM=-1
fi

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_TAG=v2.0-alpha
APP_VERSION=${APP_TAG}.${BUILD_NUM}

CORE_SERVER_REPO_TAG=v2.0-dev
UCD_LIB_SERVER_REPO_TAG=v2.0-dev
LORIS_SERVICE_REPO_TAG=main
TESSERACT_SERVICE_REPO_TAG=main
CAS_SERVICE_REPO_TAG=main

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

DOCKER_CACHE_TAG="latest"
LOCAL_TAG="local-dev"

# Docker Images
FCREPO_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-fcrepo
POSTGRES_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-postgres
NODE_UTILS_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-node-utils
SERVER_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-server
TRUSTED_PROXY_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-trusted-proxy
ELASTIC_SEARCH_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-elasticsearch
UCD_LIB_SERVER_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-ucd-lib-server
ESSYNC_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-essync
UCD_LIB_CLIENT_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-ucd-lib-client
LORIS_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-loris
TESSERACT_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-tesseract
CAS_IMAGE_NAME=$UCD_LIB_DOCKER_ORG/fin-cas
UCD_LIB_SERVER_IMPL=$UCD_LIB_DOCKER_ORG/fin-ucd-lib-server-impl

ALL_DOCKER_BUILD_IMAGES=( \
 $FCREPO_IMAGE_NAME $POSTGRES_IMAGE_NAME $NODE_UTILS_IMAGE_NAME \
 $SERVER_IMAGE_NAME $TRUSTED_PROXY_IMAGE_NAME $ELASTIC_SEARCH_IMAGE_NAME \
 $UCD_LIB_SERVER_IMAGE_NAME $ESSYNC_IMAGE_NAME $UCD_LIB_CLIENT_IMAGE_NAME \
 $LORIS_IMAGE_NAME $TESSERACT_IMAGE_NAME $CAS_IMAGE_NAME $UCD_LIB_SERVER_IMPL \
)

# Git
GIT=git
GIT_CLONE="$GIT clone"

ALL_GIT_REPOSITORIES=( \
 $CORE_SERVER_REPO_NAME $UCD_LIB_SERVER_REPO_NAME $LORIS_SERVICE_REPO_NAME \
 $TESSERACT_SERVICE_REPO_NAME $CAS_SERVICE_REPO_NAME \
)

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories