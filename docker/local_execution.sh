print_usage() {
  printf "Usage: TODO"
}

# Read bash arguments from flag
while getopts 'g:c:o:m:p:a:' flag; do
  case "${flag}" in
    g) GIT_URL="${OPTARG}" ;;
    c) COMMIT_SHA="${OPTARG}" ;;
    o) OAUTH_TOKEN="${OPTARG}" ;;
    m) MODEL_PATH="${OPTARG}" ;;
    p) PREFIX_PARAMS="${OPTARG}" ;;
    a) GOOGLE_APPLICATION_CREDENTIALS="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Move to Hydra package's docker directory
PROJECT_DIR=$(PWD)
DIR="$( dirname "${BASH_SOURCE[0]}" )"
cd $DIR

# Generate identifier for this training job
DATE=$(date +'%Y_%m_%d_%H_%M_%S')
HASH=$(( RANDOM % 1000 ))
JOB_NAME="job_${DATE}_id_${HASH}"

# Build and run image
docker build -t hydra_image .
docker run \
  -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/keys/key.json \
  -v "$PROJECT_DIR/$GOOGLE_APPLICATION_CREDENTIALS":/tmp/keys/key.json:ro \
  hydra_image:latest \
  --git_url=$GIT_URL \
  --commit_sha=$COMMIT_SHA \
  --oauth_token=$OAUTH_TOKEN \
  --model_path=$MODEL_PATH \
  --prefix_params="$PREFIX_PARAMS" \
  2>&1 | tee ${JOB_NAME}.log

# Move Log file to where the program is being called
cd - && mkdir -p tmp/hydra
mv ${DIR}/${JOB_NAME}.log tmp/hydra/
