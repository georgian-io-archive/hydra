#!/bin/bash

while getopts r:t:p: flag
do
  case "${flag}" in
      r) git_url=${OPTARG};;
      t) oauth_token=${OPTARG};;
      p) project_name=${OPTARG};
  esac
done

echo "Github Repo URL: $git_url"

mkdir project
cd project

git clone https://$oauth_token:x-oauth-basic@$git_url .

cd $project_name
pip install -r requirements.txt
python train.py
