ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

ENV GOTPL_URL "https://github.com/wodby/gotpl/releases/download/0.1.5/gotpl-alpine-linux-amd64-0.1.5.tar.gz"

RUN set -xe && \

    apk add --update --no-cache \
        bash \
        ca-certificates \
        curl \
        gzip \
        tar \
        unzip \
        wget && \

    wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin

COPY templates /etc/gotpl/
COPY bin /usr/local/bin/
