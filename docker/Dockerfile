FROM continuumio/miniconda3

ADD docker/executor.sh /home
WORKDIR /home

ENTRYPOINT ["sh", "executor.sh"]
