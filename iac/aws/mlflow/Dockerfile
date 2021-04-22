FROM python:3.8.0

ENV USERNAME $USERNAME
ENV PASSWORD $PASSWORD
ENV HOST $HOST
ENV PORT $PORT
ENV DBNAME $DBNAME
ENV BUCKET $BUCKET
ENV FOLDER $FOLDER

RUN pip install \
    mlflow==1.15.0 \
    boto3  \
    pymysql

EXPOSE 5000

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri mysql+pymysql://${USERNAME}:${PASSWORD}@${HOST}:${PORT}/${DBNAME} \
    --default-artifact-root s3://${BUCKET}/${FOLDER}/