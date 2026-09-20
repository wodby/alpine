# check=skip=InvalidDefaultArgInFrom

# The Makefile supplies the required digest-pinned BASE_IMAGE argument.
ARG ALPINE_VER

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG SOURCE_COMMIT
LABEL org.opencontainers.image.revision="${SOURCE_COMMIT}"

ARG ALPINE_DEV

ARG TARGETPLATFORM
ARG GOTPL_VERSION=0.6.9

# Upgrade inherited packages even when their existing versions satisfy dependencies.
RUN set -xe; \
    apk upgrade --no-cache; \
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
    gotpl_url="https://github.com/wodby/gotpl/releases/download/${GOTPL_VERSION}/gotpl-${dockerplatform/\//-}.tar.gz"; \
    wget -O- "${gotpl_url}" | tar xz --no-same-owner -C /usr/local/bin; \
    \
    rm -rf /var/cache/apk/*

COPY bin /usr/local/bin/
