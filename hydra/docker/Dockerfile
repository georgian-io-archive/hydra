FROM continuumio/miniconda3
WORKDIR /home
RUN pip install awscli boto3 mysql-connector
COPY entry.py .
ENTRYPOINT ["python", "entry.py"]
