#!/bin/bash

echo "Github Repo URL: $GIT_URL"

mkdir project
cd project

git clone https://$OAUTH_TOKEN:x-oauth-basic@$GIT_URL .

pip3 install -r requirements.txt
python3 $MODEL_PATH
