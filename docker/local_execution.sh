# Move to Hydra package's docker directory
DIR="$( dirname "${BASH_SOURCE[0]}" )"
cd $DIR

# Generate identifier for this training job
DATE=$(date +'%Y_%m_%d_%H_%M_%S')
HASH=$(( RANDOM % 1000 ))
JOB_NAME="job_${DATE}_id_${HASH}"

# Build and run image
docker build -t hydra_image .
docker run hydra_image:latest \
  --git_url=$1 \
  --commit_sha=$2 \
  --oauth_token=$3 \
  --model_path=$4 \
  --prefix_params=$5 \
  2>&1 | tee ${JOB_NAME}.log

# Move Log file to where the program is being called
cd - && mkdir -p tmp/hydra
mv ${DIR}/${JOB_NAME}.log tmp/hydra/
