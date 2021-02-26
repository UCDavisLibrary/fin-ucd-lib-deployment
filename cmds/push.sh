#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR
source ../config.sh

docker push $FCREPO_IMAGE_NAME:$CORE_SERVER_REPO_TAG
docker tag $FCREPO_IMAGE_NAME:$CORE_SERVER_REPO_TAG $FCREPO_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $POSTGRES_IMAGE_NAME:$CORE_SERVER_REPO_TAG
docker tag $POSTGRES_IMAGE_NAME:$CORE_SERVER_REPO_TAG $POSTGRES_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $NODE_UTILS_IMAGE_NAME:$CORE_SERVER_REPO_TAG
docker tag $NODE_UTILS_IMAGE_NAME:$CORE_SERVER_REPO_TAG $NODE_UTILS_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $SERVER_IMAGE_NAME:$CORE_SERVER_REPO_TAG
docker tag $SERVER_IMAGE_NAME:$CORE_SERVER_REPO_TAG $SERVER_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $TRUSTED_PROXY_IMAGE_NAME:$CORE_SERVER_REPO_TAG
docker tag $TRUSTED_PROXY_IMAGE_NAME:$CORE_SERVER_REPO_TAG $TRUSTED_PROXY_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $ELASTIC_SEARCH_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG
docker tag $ELASTIC_SEARCH_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG $ELASTIC_SEARCH_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_SERVER_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG
docker tag $UCD_LIB_SERVER_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG $UCD_LIB_SERVER_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $ESSYNC_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG
docker tag $ESSYNC_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG $ESSYNC_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_API_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG
docker tag $UCD_LIB_API_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG $UCD_LIB_API_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_CLIENT_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG
docker tag $UCD_LIB_CLIENT_IMAGE_NAME:$UCD_LIB_SERVER_REPO_TAG $UCD_LIB_CLIENT_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $LORIS_IMAGE_NAME:$LORIS_SERVICE_REPO_TAG
docker tag $LORIS_IMAGE_NAME:$LORIS_SERVICE_REPO_TAG $LORIS_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $TESSERACT_IMAGE_NAME:$TESSERACT_SERVICE_REPO_TAG
docker tag $TESSERACT_IMAGE_NAME:$TESSERACT_SERVICE_REPO_TAG $TESSERACT_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $CAS_IMAGE_NAME:$CAS_SERVICE_REPO_TAG
docker tag $CAS_IMAGE_NAME:$CAS_SERVICE_REPO_TAG $CAS_IMAGE_NAME:$DOCKER_CACHE_TAG

docker push $UCD_LIB_SERVER_IMPL:$APP_TAG
docker tag $UCD_LIB_SERVER_IMPL:$APP_TAG $UCD_LIB_SERVER_IMPL:$DOCKER_CACHE_TAG

for image in "${ALL_DOCKER_BUILD_IMAGES[@]}"; do
  docker push $image:$DOCKER_CACHE_TAG || true
done
