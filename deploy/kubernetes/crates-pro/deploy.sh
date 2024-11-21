#!/bin/bash
set -ex

readonly IMAGE_NAME="localhost:30500/my-postgresql:20240909"

docker build -t ${IMAGE_NAME} .
docker push ${IMAGE_NAME}

kubectl apply -f postgresql-secret.yaml -n postgresql
kubectl apply -f postgresql.yaml -n postgresql
