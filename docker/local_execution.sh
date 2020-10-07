docker build -t hydra_image .

# Create logs folder if it doesn't exist
mkdir -p logs/docker

docker run \
  -e GIT_URL=$1 \
  -e COMMIT_SHA=$2 \
  -e MODEL_PATH=$3 \
  -e OAUTH_TOKEN=$4 \
  hydra_image:latest > logs/docker/$(date +'%Y_%m_%d_%H_%M_%S').log
