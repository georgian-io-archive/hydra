FROM python:3.8.0

ENV BUCKET hydra-mlflow-bucket
ENV USERNAME hydramlflowuser
ENV PASSWORD dbA2jWGFuyssYD7Ngf6RLVw
ENV HOST hydra-mlflow-backend-store-test.ckmoellmwsrn.us-east-1.rds.amazonaws.com
ENV PORT 5432
ENV DATABASE postgres

RUN pip install \
    mlflow \
    boto3  \
    psycopg2

EXPOSE 5000

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri postgresql://${USERNAME}:${PASSWORD}@${HOST}:${PORT}/${DATABASE} \
    --default-artifact-root s3://${BUCKET}/test/