#! /bin/bash

######### MAIN CONFIG ##########
# Set your main build setup here
################################

# Main version number we are tagging the app with.  This should
# match the fin-ucd-lib-deployment tag number as well.  Always update
# this when you cut a new version of the app!
APP_VERSION=1.2

UCD_LIB_DOCKER_ORG=ucdlib
FIN_UCD_SERVER_NAME=fin-ucd-server
UCD_CORE_SERVER_NAME=fin-ucd-core-server

UCD_SERVER_VERSION=$APP_VERSION

UCD_CORE_SERVER_VERSION=1.0.0
FCREPO_VERSION=1.0.0
PG_VERSION=1.0.0
ELASTIC_SEARCH_VERSION=1.0.0
TRUSTED_PROXY_VERSION=1.0.0

UCD_LIB_CLIENT_VERSION=0.2.0
ESSYNC_VERSION=0.1.0
CAS_VERSION=0.0.1

LORIS_VERSION=1.0.1
TESSERACT_VERSION=0.0.1

TEMPLATE_VAR_ARRAY=( "UCD_SERVER_VERSION" \
  "UCD_CORE_SERVER_VERSION" "FCREPO_VERSION" "PG_VERSION" \
  "ELASTIC_SEARCH_VERSION" "TRUSTED_PROXY_VERSION" "UCD_LIB_CLIENT_VERSION" \
  "ESSYNC_VERSION" "CAS_VERSION" "LORIS_VERSION" "TESSERACT_VERSION")