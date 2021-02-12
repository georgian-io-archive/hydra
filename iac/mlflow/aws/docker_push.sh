aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 823217009914.dkr.ecr.us-east-1.amazonaws.com
docker build -t hydra-mlflow-server-aws .
docker tag hydra-mlflow-server-aws:latest 823217009914.dkr.ecr.us-east-1.amazonaws.com/hydra-mlflow-server-aws:latest
docker push 823217009914.dkr.ecr.us-east-1.amazonaws.com/hydra-mlflow-server-aws:latest