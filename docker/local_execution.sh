docker build -t hydra_image .

docker run \
  -e GIT_URL=$1 \
  -e COMMIT_SHA=$2 \
  -e MODEL_PATH=$3 \
  -e OAUTH_TOKEN=$4 \
  hydra_image:latest
