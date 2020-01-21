ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

file=prod.yaml
content=$(cat "templates/$file")

source ./config.sh

for key in ${TEMPLATE_VAR_ARRAY[@]}; do
  content=$(echo "$content" | sed "s/{{$key}}/${!key}/g") 
done

echo "$content" > docker-compose.yaml
chmod a+x docker-compose.yaml