docker build -t hydra_image .

# Create logs folder if it doesn't exist
mkdir -p tmp/hydra

docker run \
  -e GIT_URL=$1 \
  -e COMMIT_SHA=$2 \
  -e MODEL_PATH=$3 \
  -e OAUTH_TOKEN=$4 \
  hydra_image:latest > tmp/hydra/$(date +'%Y_%m_%d_%H_%M_%S').log
