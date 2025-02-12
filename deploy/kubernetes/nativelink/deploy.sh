#!/bin/bash
set -ex

readonly IMAGE_NAME="localhost:30500/nativelink-worker:20250212"

docker build -t ${IMAGE_NAME} -f ../../../remote_execution/Dockerfile ../../../remote_execution
docker push ${IMAGE_NAME}

kubectl apply -f nativelink.yaml -n nativelink
