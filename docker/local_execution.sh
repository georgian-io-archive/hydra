
DIR="$( dirname "${BASH_SOURCE[0]}" )"
LOG_NAME=$(date +'%Y_%m_%d_%H_%M_%S')

cd $DIR
#TODO Bug fix building hydra image
docker build -t hydra_image .
# Create logs folder if it doesn't exist

docker run \
  -e GIT_URL=$1 \
  -e COMMIT_SHA=$2 \
  -e OAUTH_TOKEN=$3 \
  -e MODEL_PATH=$4 \
  -e PREFIX_PARAMS=$5 \
  hydra_image:latest 2>&1 | tee ${LOG_NAME}.log

cd -
pwd
mkdir -p tmp/hydra

mv ${DIR}/${LOG_NAME}.log tmp/hydra/
