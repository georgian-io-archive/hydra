registry_id=$(aws ecr describe-registry | python3 -c "import sys, json; print(json.load(sys.stdin)['registryId'])")
region=""
repository=""

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin "${registry_id}.dkr.ecr.${region}.amazonaws.com"
docker build -t ${repository} .
docker tag ${repository}:latest "${registry_id}.dkr.ecr.${region}.amazonaws.com/${repository}:latest"
docker push "${registry_id}.dkr.ecr.${region}.amazonaws.com/${repository}:latest"