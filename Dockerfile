FROM python:3.9-alpine3.16

ARG VERSION=master

ADD https://github.com/atomicals/atomicals-electrumx/archive/${VERSION}.zip /tmp/

RUN set -ex && \
    apk add --no-cache build-base openssl leveldb-dev && \
    cd /tmp && unzip ${VERSION}.zip && \
    mv /tmp/atomicals-electrumx-${VERSION#v} /electrumx && \
    cd /electrumx && \
    pip install .[ujson,uvloop,crypto] && \
    apk del build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]

ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV COIN=BitCoin
ENV SERVICES=tcp://:50001
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""

WORKDIR /data

COPY ./bin /usr/local/bin

EXPOSE 50001

CMD ["init"]