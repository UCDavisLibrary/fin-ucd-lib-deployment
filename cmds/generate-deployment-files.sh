ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../templates

TEMPLATE_VAR_ARRAY=("FIN_SERVER_REPO_TAG" "APP_TAG")


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