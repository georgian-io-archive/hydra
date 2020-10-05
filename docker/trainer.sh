#!/bin/bash

echo "Github Repo URL: $GIT_URL"

mkdir project
cd project

git clone -b test-samples https://$OAUTH_TOKEN:x-oauth-basic@$GIT_URL .

cd $PROJECT_NAME
pip install -r requirements.txt
python train.py
