ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

ARG ALPINE_DEV

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
    if [ -n "${ALPINE_DEV}" ]; then \
        apk add --update git coreutils jq sed gawk grep gnupg; \
    fi; \
    \
    gotpl_url="https://github.com/wodby/gotpl/releases/download/0.1.5/gotpl-alpine-linux-amd64-0.1.5.tar.gz"; \
    wget -qO- "${gotpl_url}" | tar xz -C /usr/local/bin; \
    \
    rm -rf /var/cache/apk/*

COPY bin /usr/local/bin/
