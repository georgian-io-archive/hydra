FROM python:3.8.0

ENV DIALECT mysql
ENV DRIVER pymysql
ENV USERNAME <enter username>
ENV PASSWORD <enter password>
ENV HOST terraform-20210212062757265400000001.ckmoellmwsrn.us-east-1.rds.amazonaws.com
ENV PORT 3306
ENV DATABASE mlflowdb
ENV BUCKET hydra-mlflow-bucket
ENV FOLDER logging

RUN pip install \
    mlflow \
    boto3  \
    pymysql

EXPOSE 5000

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri ${DIALECT}+${DRIVER}://${USERNAME}:${PASSWORD}@${HOST}:${PORT}/${DATABASE} \
    --default-artifact-root s3://${BUCKET}/${LOGGING}/