ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

TEMPLATE_VAR_ARRAY=("CORE_SERVER_REPO_TAG" "UCD_LIB_SERVER_REPO_TAG" "APP_VERSION"
  "LORIS_SERVICE_REPO_TAG" "TESSERACT_SERVICE_REPO_TAG" "CAS_SERVICE_REPO_TAG")


source ../config.sh

content=$(cat prod.yaml)
for key in ${TEMPLATE_VAR_ARRAY[@]}; do
  content=$(echo "$content" | sed "s/{{$key}}/${!key}/g") 
done
echo "$content" > ../docker-compose.yaml

content=$(cat local-dev.yaml)
for key in ${TEMPLATE_VAR_ARRAY[@]}; do
  content=$(echo "$content" | sed "s/{{$key}}/local-dev/g") 
done
echo "$content" > ../fin-local-dev/docker-compose.yaml