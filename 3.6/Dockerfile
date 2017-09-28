FROM alpine:3.6

ENV GOTPL_URL "https://github.com/wodby/gotpl/releases/download/0.1.5/gotpl-alpine-linux-amd64-0.1.5.tar.gz"

RUN set -xe && \

    apk add --update --no-cache \
        gzip \
        tar \
        unzip \
        wget && \

    wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin

COPY bin /usr/local/bin/
