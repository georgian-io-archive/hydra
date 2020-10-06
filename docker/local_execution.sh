#!/bin/bash
docker build -t hydra_image .

docker run \
  -e GIT_URL=github.com/georgianpartners/hydra-ml-projects \
  -e MODEL_PATH=$1 \
  -e OAUTH_TOKEN=$2 \
  hydra_image:latest
