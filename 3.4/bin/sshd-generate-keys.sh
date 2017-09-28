#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

dir="${1:-/etc/ssh}"

mkdir -p "${dir}"
ssh-keygen -qb 2048 -t rsa -N "" -f "${dir}/ssh_host_rsa_key"
ssh-keygen -qt dsa -N '' -f "${dir}/ssh_host_dsa_key"
ssh-keygen -qt ecdsa -N '' -f "${dir}/ssh_host_ecdsa_key"
ssh-keygen -qt ed25519 -N '' -f "${dir}/ssh_host_ed25519_key"
chmod 0600 "${dir}"/*_key
chmod 0644 "${dir}"/*.pub