#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR
source ../config.sh

# Wipe the current repository dir
if [ -d $REPOSITORY_DIR ] ; then
  rm -rf $REPOSITORY_DIR
fi
mkdir -p $REPOSITORY_DIR

# Core Server
$GIT_CLONE $CORE_SERVER_REPO_URL.git \
  --branch $CORE_SERVER_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME

# UCD Library Server
$GIT_CLONE $UCD_LIB_SERVER_REPO_URL.git \
  --branch $UCD_LIB_SERVER_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME

## Loris Service
$GIT_CLONE $LORIS_SERVICE_REPO_URL.git \
  --branch $LORIS_SERVICE_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$LORIS_SERVICE_REPO_NAME

## Loris Service
$GIT_CLONE $TESSERACT_SERVICE_REPO_URL.git \
  --branch $TESSERACT_SERVICE_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$TESSERACT_SERVICE_REPO_NAME

## CAS Service
$GIT_CLONE $CAS_SERVICE_REPO_URL.git \
  --branch $CAS_SERVICE_REPO_TAG \
  --depth 1 \
  $REPOSITORY_DIR/$CAS_SERVICE_REPO_NAME