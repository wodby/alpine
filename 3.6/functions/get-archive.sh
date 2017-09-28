#!/usr/bin/env bash

get_archive() {
    source=$1
    tmp_destination=$2
    allowed_archives="${@:3}"

    # Allowed by default.
    if [[ -z "${allowed_archives}" ]]; then
        allowed_archives="zip tgz tar.gz tar gz"
    fi

    [[ -d "${tmp_destination}" ]] && rm -rf "${tmp_destination}"

    mkdir -p "${tmp_destination}"

    if [[ "${source}" =~ ^https?:// ]]; then
        wget -q -P "${tmp_destination}" "${source}"
    else
        mv "${source}" "${tmp_destination}"
    fi

    archive=$(find "${tmp_destination}" -type f)
    regex="${allowed_archives// /|}"
    regex="${regex/./\.}"

    if [[ "${archive}" =~ "${regex}"$ ]]; then
        if [[ "${archive}" =~ \.zip$ ]]; then
            unzip "${archive}" -x "__MACOSX/*" -d "${tmp_destination}"
            rm "${archive}"
        elif [[ "${archive}" =~ \.tgz$ ]] || [[ "${archive}" =~ \.tar.gz$ ]]; then
            tar zxf "${archive}" --exclude="./__MACOSX" -C "${tmp_destination}"
            rm "${archive}"
        elif [[ "${archive}" =~ \.tar$ ]]; then
            tar xf "${archive}" --exclude="./__MACOSX" -C "${tmp_destination}"
            rm "${archive}"
        elif [[ "${archive}" =~ \.gz$ ]]; then
            gunzip "${archive}"
        fi
    else
        echo >&2 'Invalid file format. Expecting .zip .tar.gz .tgz archive'
        exit 1
    fi
}
