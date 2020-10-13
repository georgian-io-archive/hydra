# Move to Hydra package's docker directory
DIR="$( dirname "${BASH_SOURCE[0]}" )"
cd $DIR

# Generate identifier for this training job
DATE=$(date +'%Y_%m_%d_%H_%M_%S')
HASH=$(( RANDOM % 1000 ))
JOB_NAME="job_${DATE}_id_${HASH}"

# Export env variables to push docker image
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
export IMAGE_REPO_NAME=hydra_image
export IMAGE_TAG=${JOB_NAME}
export IMAGE_URI=gcr.io/${PROJECT_ID}/${IMAGE_REPO_NAME}:${IMAGE_TAG}

# Build and push image
docker build -t $IMAGE_URI .
docker push $IMAGE_URI

# Submit training job
gcloud ai-platform jobs submit training $JOB_NAME \
  --master-image-uri $IMAGE_URI \
  --region "us-west1" \
  -- \
  --git_url=$1 \
  --commit_sha=$2 \
  --oauth_token=$3 \
  --model_path=$4 \
  --prefix_params=$5 \
