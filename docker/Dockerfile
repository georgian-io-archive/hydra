FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN apt-get install python3-pip -y

ADD trainer.sh /home
WORKDIR /home

ENTRYPOINT ["sh", "trainer.sh"]
