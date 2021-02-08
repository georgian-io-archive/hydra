FROM continuumio/miniconda3
WORKDIR /home
COPY entry.py .
RUN pip install hydra-ml==0.3.8
ENTRYPOINT ["python", "entry.py"]
