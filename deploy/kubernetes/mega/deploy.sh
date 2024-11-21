#!/bin/bash
set -ex

export MEGA_RANDOM_IMAGE_TAG="$(openssl rand -hex 4)"
readonly MONO_PG_IMAGE_NAME="localhost:30500/mono-pg:${MEGA_RANDOM_IMAGE_TAG}"
readonly MONO_ENGINE_IMAGE_NAME="localhost:30500/mono-engine:${MEGA_RANDOM_IMAGE_TAG}"
readonly MONO_UI_IMAGE_NAME="localhost:30500/mono-ui:${MEGA_RANDOM_IMAGE_TAG}"

docker build -t ${MONO_PG_IMAGE_NAME} -f ./mega/docker/mono-pg-dockerfile ./mega
docker push ${MONO_PG_IMAGE_NAME}
docker build -t ${MONO_ENGINE_IMAGE_NAME} -f ./mega/docker/mono-engine-dockerfile ./mega
docker push ${MONO_ENGINE_IMAGE_NAME}
docker build -t ${MONO_UI_IMAGE_NAME} -f ./mega/docker/mono-ui-dockerfile ./mega
docker push ${MONO_UI_IMAGE_NAME}

kubectl apply -f proxy-config.yaml -n mega
envsubst < mono-pg.yaml | kubectl apply -f - -n mega
sleep 5
envsubst < mono-engine.yaml | kubectl apply -f - -n mega
envsubst < mono-ui.yaml | kubectl apply -f - -n mega
