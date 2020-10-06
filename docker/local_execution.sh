#!/bin/bash
docker build -t hydra_image .

docker run \
  -e GIT_URL=$1 \
  -e MODEL_PATH=$2 \
  -e OAUTH_TOKEN=$3 \
  hydra_image:latest
