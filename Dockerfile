ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

ENV GOTPL_VER 0.1.5

RUN set -xe; \
    \
    apk add --update --no-cache \
        bash \
        ca-certificates \
        curl \
        gzip \
        tar \
        unzip \
        wget; \
    \
    gotpl_url="https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz -C /usr/local/bin; \
    \
    rm -rf /var/cache/apk/*

COPY bin /usr/local/bin/
