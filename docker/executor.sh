echo "Github Repo: https://$OAUTH_TOKEN:x-oauth-basic@${GIT_URL}/tree/${COMMIT_SHA}"

mkdir project
cd project

git clone https://$OAUTH_TOKEN:x-oauth-basic@$GIT_URL .
git checkout $COMMIT_SHA

conda env create -f environment.yml
conda run -n hydra /bin/bash -c

conda run -n hydra $PREFIX_PARAMS python3 $MODEL_PATH
