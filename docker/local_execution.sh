
DIR="$( dirname "${BASH_SOURCE[0]}" )"

# Add random Hash
LOG_NAME=$(date +'%Y_%m_%d_%H_%M_%S')

cd $DIR
docker build -t hydra_image .

docker run \
  -e GIT_URL=$1 \
  -e COMMIT_SHA=$2 \
  -e OAUTH_TOKEN=$3 \
  -e MODEL_PATH=$4 \
  -e PREFIX_PARAMS=$5 \
  hydra_image:latest 2>&1 | tee ${LOG_NAME}.log

# Move Log file to where the program is being called
cd -
mkdir -p tmp/hydra
mv ${DIR}/${LOG_NAME}.log tmp/hydra/
