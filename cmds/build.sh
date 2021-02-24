#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

echo "Starting docker build"

# Use buildkit to speedup local builds
# Not supported in google cloud build yet
if [[ -z $GCLOUD_BUILD ]]; then
  echo "Using docker buildkit"
  export DOCKER_BUILDKIT=1
fi

# Additionally set local-dev tags used by 
# local development docker-compose file
if [[ ! -z $LOCAL_BUILD ]]; then
  echo "Using local tags: $LOCAL_TAG"
  CORE_SERVER_REPO_TAG=$LOCAL_TAG
  UCD_LIB_SERVER_REPO_TAG=$LOCAL_TAG
  LORIS_SERVICE_REPO_TAG=$LOCAL_TAG
  TESSERACT_SERVICE_REPO_TAG=$LOCAL_TAG
  CAS_SERVICE_REPO_TAG=$LOCAL_TAG
  APP_TAG=$LOCAL_TAG
fi


# Core Server - fcrepo
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CORE_SERVER_REPO_HASH=${CORE_SERVER_REPO_HASH} \
  -t $FCREPO_IMAGE_NAME:$CORE_SERVER_REPO_TAG \
  --cache-from $FCREPO_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME/fcrepo

# Core Server - postgres
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CORE_SERVER_REPO_HASH=${CORE_SERVER_REPO_HASH} \
  -t $POSTGRES_IMAGE_NAME:$CORE_SERVER_REPO_TAG \
  --cache-from $POSTGRES_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME/postgres

# Core Server - fin node utils
docker build \
  -t $NODE_UTILS_IMAGE_NAME:$CORE_SERVER_REPO_TAG \
  --cache-from $NODE_UTILS_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME/node-utils

# Core Server - server
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CORE_SERVER_REPO_HASH=${CORE_SERVER_REPO_HASH} \
  -t $SERVER_IMAGE_NAME:$CORE_SERVER_REPO_TAG \
  --cache-from $SERVER_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME/server

# Core Server - trusted proxy
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CORE_SERVER_REPO_HASH=${CORE_SERVER_REPO_HASH} \
  -t $TRUSTED_PROXY_IMAGE_NAME:$CORE_SERVER_REPO_TAG \
  --cache-from $TRUSTED_PROXY_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CORE_SERVER_REPO_NAME/trusted-proxy

UCD_LIB_SERVER_REPO_HASH=$(git -C $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME log -1 --pretty=%h)

# UCD Library Server - elastic search
docker build \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  -t $ELASTIC_SEARCH_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $ELASTIC_SEARCH_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/elastic-search

# UCD Library Server - server
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  -t $UCD_LIB_SERVER_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $UCD_LIB_SERVER_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/server

# UCD Library Server - essync
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  -t $ESSYNC_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $ESSYNC_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/services/essync

# UCD Library Server - node utils
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  -t $UCD_LIB_NODE_UTILS_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $UCD_LIB_NODE_UTILS_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/node-utils

NODEJS_BASE=$UCD_LIB_NODE_UTILS_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG

echo "$NODEJS_BASE"

# UCD Library Server - api
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  -t $UCD_LIB_API_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $UCD_LIB_API_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/services/api

# UCD Library Server - ucd-lib-client
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  --build-arg NODEJS_BASE=${NODEJS_BASE} \
  -t $UCD_LIB_CLIENT_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG \
  --cache-from $UCD_LIB_CLIENT_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$UCD_LIB_SERVER_REPO_NAME/services/ucd-lib-client

# Loris Service
LORIS_SERVICE_REPO_HASH=$(git -C $REPOSITORY_DIR/$LORIS_SERVICE_REPO_NAME log -1 --pretty=%h)
docker build \
  --build-arg LORIS_SERVICE_REPO_TAG=${LORIS_SERVICE_REPO_TAG} \
  --build-arg LORIS_SERVICE_REPO_HASH=${LORIS_SERVICE_REPO_HASH} \
  -t $LORIS_IMAGE_NAME:$LORIS_SERVICE_REPO_TAG \
  --cache-from $LORIS_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$LORIS_SERVICE_REPO_NAME

# Tesseract Service
TESSERACT_SERVICE_REPO_HASH=$(git -C $REPOSITORY_DIR/$TESSERACT_SERVICE_REPO_NAME log -1 --pretty=%h)
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg TESSERACT_SERVICE_REPO_TAG=${TESSERACT_SERVICE_REPO_TAG} \
  --build-arg TESSERACT_SERVICE_REPO_HASH=${TESSERACT_SERVICE_REPO_HASH} \
  -t $TESSERACT_IMAGE_NAME:$TESSERACT_SERVICE_REPO_TAG \
  --cache-from $TESSERACT_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$TESSERACT_SERVICE_REPO_NAME

# CAS Service
CAS_SERVICE_REPO_HASH=$(git -C $REPOSITORY_DIR/$CAS_SERVICE_REPO_NAME log -1 --pretty=%h)
docker build \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CAS_SERVICE_REPO_TAG=${CAS_SERVICE_REPO_TAG} \
  --build-arg CAS_SERVICE_REPO_HASH=${CAS_SERVICE_REPO_HASH} \
  -t $CAS_IMAGE_NAME:$CAS_SERVICE_REPO_TAG \
  --cache-from $CAS_IMAGE_NAME:$DOCKER_CACHE_TAG \
  $REPOSITORY_DIR/$CAS_SERVICE_REPO_NAME

# UCD Library Server Impl
docker build \
  --build-arg APP_VERSION=${APP_VERSION} \
  --build-arg CORE_SERVER_REPO_TAG=${CORE_SERVER_REPO_TAG} \
  --build-arg CORE_SERVER_REPO_HASH=${CORE_SERVER_REPO_HASH} \
  --build-arg UCD_LIB_SERVER_REPO_TAG=${UCD_LIB_SERVER_REPO_TAG} \
  --build-arg UCD_LIB_SERVER_REPO_HASH=${UCD_LIB_SERVER_REPO_HASH} \
  --build-arg LORIS_SERVICE_REPO_TAG=${LORIS_SERVICE_REPO_TAG} \
  --build-arg LORIS_SERVICE_REPO_HASH=${LORIS_SERVICE_REPO_HASH} \
  --build-arg TESSERACT_SERVICE_REPO_TAG=${TESSERACT_SERVICE_REPO_TAG} \
  --build-arg TESSERACT_SERVICE_REPO_HASH=${TESSERACT_SERVICE_REPO_HASH} \
  --build-arg CAS_SERVICE_REPO_TAG=${CAS_SERVICE_REPO_TAG} \
  --build-arg CAS_SERVICE_REPO_HASH=${CAS_SERVICE_REPO_HASH} \
  -t $UCD_LIB_SERVER_IMPL:$APP_TAG \
  --cache-from $UCD_LIB_SERVER_IMPL:$DOCKER_CACHE_TAG \
  ucd-lib-server-impl
