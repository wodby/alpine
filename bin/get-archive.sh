#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

source=$1
tmp_dest=$2
allowed_archives="${@:3}"

_untar() {
    archive=$1
    destination=$2
    zip=$3
    options="xf"

    if [[ -n "${zip}" ]]; then
        options+="z"
    fi

    tar "${options}" "${archive}" \
        --delay-directory-restore \
        --no-same-owner \
        --exclude="./__MACOSX" \
        -C "${destination}"
}

if [[ -z "${source}" || -z "${tmp_dest}" ]]; then
    echo "ERROR. Missing params!"
    exit
fi

# Allowed by default.
if [[ -z "${allowed_archives}" ]]; then
    allowed_archives="zip tgz tar.gz tar gz"
else
    IFS=' ' read -r -a array <<< "${allowed_archives}"

    for element in "${array[@]}"
    do
        if [[ ! "${element}" =~ ^(zip|tgz|tar\.gz|tar|gz)$ ]]; then
            echo "Unsupported archive. Allowed: zip tgz tar.gz tar gz"
            exit 1
        fi
    done
fi

[[ -d "${tmp_dest}" ]] && rm -rf "${tmp_dest}"

mkdir -p "${tmp_dest}"

if [[ "${source}" =~ ^https?:// ]]; then
    wget -q -P "${tmp_dest}" "${source}"
else
    mv "${source}" "${tmp_dest}"
fi

archive=$(find "${tmp_dest}" -type f)
regex="${allowed_archives/\./\\.}"
regex="\.(${regex// /|})$"

if [[ "${archive}" =~ ${regex} ]]; then
    if [[ "${archive}" =~ \.zip$ ]]; then
        unzip -qq "${archive}" -x "__MACOSX/*" -d "${tmp_dest}"
        rm "${archive}"
    elif [[ "${archive}" =~ \.tgz$ ]] || [[ "${archive}" =~ \.tar.gz$ ]]; then
        _untar "${archive}" "${tmp_dest}" 1
        rm "${archive}"
    elif [[ "${archive}" =~ \.tar$ ]]; then
        _untar "${archive}" "${tmp_dest}"
        rm "${archive}"
    elif [[ "${archive}" =~ \.gz$ ]]; then
        gunzip "${archive}"
    fi
else
    echo >&2 "Invalid file format. Expecting ${allowed_archives} archive"
    exit 1
fi
