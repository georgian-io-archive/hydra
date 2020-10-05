#!/bin/bash

while getopts r:t: flag
do
  case "${flag}" in
      r) git_url=${OPTARG};;
      t) oauth_token=${OPTARG};
  esac
done

echo "Github Repo URL: $git_url";
git clone https://$oauth_token:x-oauth-basic@$git_url
