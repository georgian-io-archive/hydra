FROM continuumio/miniconda3
WORKDIR /home
RUN pip install awscli
COPY entry.py .
ENTRYPOINT ["python", "entry.py"]
