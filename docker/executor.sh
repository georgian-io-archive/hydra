echo "Github Repo: https://$OAUTH_TOKEN:x-oauth-basic@${GIT_URL}/tree/${COMMIT_SHA}"

mkdir project
cd project

git clone https://$OAUTH_TOKEN:x-oauth-basic@$GIT_URL .
git checkout $COMMIT_SHA

pip3 install -r requirements.txt
python3 $MODEL_PATH
