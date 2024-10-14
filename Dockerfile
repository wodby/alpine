ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

ARG ALPINE_DEV

ARG TARGETPLATFORM

RUN set -xe; \
    \
    apk add --update --no-cache \
        bash \
        ca-certificates \
        curl \
        gzip \
        p7zip \
        tar \
        unzip \
        wget; \
    \
    if [ -n "${ALPINE_DEV}" ]; then \
        apk add --update git coreutils jq sed gawk grep gnupg python3; \
    fi; \
    \
    dockerplatform=${TARGETPLATFORM:-linux/amd64};\
    gotpl_url="https://github.com/wodby/gotpl/releases/download/latest/gotpl-${TARGETPLATFORM/\//-}.tar.gz"; \
    wget -O- "${gotpl_url}" | tar xz --no-same-owner -C /usr/local/bin; \
    \
    rm -rf /var/cache/apk/*

COPY bin /usr/local/bin/
