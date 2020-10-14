GIT_URL=''
COMMIT_SHA=''
OAUTH_TOKEN=''
MODEL_PATH=''
PREFIX_PARAMS=''
REGION=''

print_usage() {
  printf "Usage: TODO"
}

# Read bash arguments from flag
while getopts 'g:c:o:m:r:t:p' flag; do
  case "${flag}" in
    g) GIT_URL="${OPTARG}" ;;
    c) COMMIT_SHA="${OPTARG}" ;;
    o) OAUTH_TOKEN="${OPTARG}" ;;
    m) MODEL_PATH="${OPTARG}" ;;
    r) REGION="${OPTARG}" ;;
    t) IMAGE_TAG="${OPTARG}" ;;
    p) PREFIX_PARAMS="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

# Move to Hydra package's docker directory
DIR="$( dirname "${BASH_SOURCE[0]}" )"
cd $DIR

# Generate identifier for this training job
DATE=$(date +'%Y_%m_%d_%H_%M_%S')
HASH=$(( RANDOM % 1000 ))
JOB_NAME="job_${DATE}_id_${HASH}"

# If tag name is empty, generate a tag name
if [[ $IMAGE_TAG == '' ]]
then
  export IMAGE_TAG=${JOB_NAME}
fi

# Export env variables to push docker image
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
export IMAGE_REPO_NAME=hydra_image
export IMAGE_URI=gcr.io/${PROJECT_ID}/${IMAGE_REPO_NAME}:${IMAGE_TAG}

EXISTING_TAGS=$(gcloud container images list-tags --filter="tags:${IMAGE_TAG}" --format=json gcr.io/${PROJECT_ID}/${IMAGE_REPO_NAME})
if [[ "$EXISTING_TAGS" == "[]" ]]; then
  echo "Building and pushing a new Docker image to Google Cloud Container Registry."
  # Build and push image
  docker build -t $IMAGE_URI .
  docker push $IMAGE_URI
else
  echo "Using stored Docker images in Google Cloud Container Registry."
fi

# Submit training job
gcloud ai-platform jobs submit training $JOB_NAME \
  --master-image-uri $IMAGE_URI \
  --region=$REGION \
  -- \
  --git_url=$GIT_URL \
  --commit_sha=$COMMIT_SHA \
  --oauth_token=$OAUTH_TOKEN \
  --model_path=$MODEL_PATH \
  --prefix_params=$PREFIX_PARAMS
