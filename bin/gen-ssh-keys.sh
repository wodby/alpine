#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

# Key types, e.g. "rsa dsa ecdsa ed25519":
IFS=' ' read -r -a types <<< "${1:-rsa}"

dir="${2:-/etc/ssh}"

mkdir -p "${dir}"

for type in "${types[@]}"
do
    flags="-q"

    # Always 2048 bits for RSA.
    if [[ "${type}" == "rsa" ]]; then
        flags="${flags} -b 2048"
    fi

    if [[ ! -f "${dir}/ssh_${type}_key" ]]; then
        ssh-keygen ${flags} -t "${type}" -N "" -f "${dir}/ssh_${type}_key"
    fi

    chmod 0600 "${dir}/ssh_${type}_key"
    chmod 0644 "${dir}/ssh_${type}_key.pub"
done

