FROM python:3.9.18-bullseye AS builder

ARG VERSION=master

ADD https://github.com/atomicals/atomicals-electrumx/archive/${VERSION}.zip /tmp/

RUN set -ex && \
    cd /tmp && unzip ${VERSION}.zip && \
    mv /tmp/atomicals-electrumx-${VERSION} /usr/src/app

WORKDIR /usr/src/app

# Install the libs needed by rocksdb (including development headers)
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    librocksdb-dev libsnappy-dev libbz2-dev libz-dev liblz4-dev libleveldb-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv venv \
    && venv/bin/pip install Cython==0.29.28 \
    && venv/bin/pip install --no-cache-dir e-x[rapidjson,uvloop,crypto,rocksdb]==1.16.0


FROM python:3.9.18-slim-bullseye

# Install the libs needed by rocksdb (no development headers or statics)
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    netcat librocksdb6.11 libsnappy1v5 libbz2-1.0 zlib1g liblz4-1 libleveldb1d \
    && rm -rf /var/lib/apt/lists/*

ENV SERVICES="tcp://:50001"
ENV COIN=Bitcoin
ENV DB_DIRECTORY=/data
ENV DAEMON_URL="http://username:password@hostname:port/"
ENV ALLOW_ROOT=true
ENV EVENT_LOOP_POLICY=uvloop
ENV MAX_SEND=10000000
ENV BANDWIDTH_UNIT_COST=50000
ENV CACHE_MB=2000

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .

VOLUME /data

RUN mkdir -p "$DB_DIRECTORY"

CMD ["/usr/src/app/venv/bin/python", "/usr/src/app/venv/bin/electrumx_server"]