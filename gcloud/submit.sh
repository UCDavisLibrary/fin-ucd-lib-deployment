#! /bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..

echo "Submitting build to Google Cloud..."
gcloud builds submit --config ./gcloud/cloudbuild.yaml .