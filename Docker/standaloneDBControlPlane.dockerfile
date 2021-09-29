# syntax=docker/dockerfile:1

FROM ubuntu:20.04
WORKDIR /worldql
RUN apt-get update
RUN apt-get install -y wget 
RUN wget -O WorldQLServer https://github.com/WorldQL/mammoth/releases/download/v0.02-alpha/WorldQLServer
RUN chmod +x WorldQLServer

ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && \
  apt-get install -y libpqxx-dev libzmq3-dev


# set up postgres
RUN apt-get install -y postgresql postgresql-contrib
RUN sed -i -r 's/port = 5432/port=5433/' /etc/postgresql/12/main/postgresql.conf
USER postgres
ENV PGPORT=5433
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker


ENV WQL_LEAF_SQUARE_SIZE=16
ENV WQL_TREE_DEGREE=512
ENV WQL_NUM_LEVELS=2
ENV WQL_ROOTS_PER_TABLE=8
ENV WQL_POSTGRES_CONNECTION_STRING="postgresql://docker:docker@localhost?port=5433&dbname=docker"

ADD Standalone/wrapper.sh ./wrapper.sh
CMD ["./wrapper.sh"]
