# syntax=docker/dockerfile:1.5-labs

FROM python:3.10-alpine3.16

ARG VERSION=master
ADD https://github.com/atomicals/atomicals-electrumx.git#${VERSION} /electrumx

WORKDIR /electrumx

RUN set -ex && \
    apk add --no-cache build-base git openssl leveldb-dev && \
    pip install .[ujson,uvloop,crypto] && \
    apk del build-base git

VOLUME ["/data"]

ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV COIN=BitCoin
ENV SERVICES=tcp://0.0.0.0:50001,ws://0.0.0.0:50002,rpc://0.0.0.0:8000,http://0.0.0.0:8080
ENV HOST ""
ENV CACHE_MB=2000
ENV MAX_SEND=3000000
ENV COST_SOFT_LIMIT=100000
ENV COST_HARD_LIMIT=1000000

COPY ./bin /usr/local/bin

EXPOSE 50001 50002 8000 8080

HEALTHCHECK --start-period=180s --retries=5760 \
  CMD netstat -ltn | grep -c ":8080" > /dev/null; if [ 0 != $? ]; then exit 1; fi;

CMD ["my_init"]
