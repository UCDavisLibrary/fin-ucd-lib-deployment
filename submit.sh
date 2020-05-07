#! /bin/bash

echo "Submitting build to Google Cloud..."
gcloud builds submit --config ./gcloud/cloudbuild.yaml .