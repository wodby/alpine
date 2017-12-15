#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

dir="${1}"
subj="/CN=${2:-example.com}"
name="${3:-auth}"
days="${4:-3650}"
key="${5:-rsa:2048}"

filepath="${dir}/${name}"

openssl req -nodes -newkey "${key}" -keyout "${filepath}.key" -out "${filepath}.csr" -subj "/CN=${subj}"
openssl x509 -in "${filepath}.csr" -out "${filepath}.crt" -req -signkey "${filepath}.key" -days "${days}"
