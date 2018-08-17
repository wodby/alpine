#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

s3url="https://s3.amazonaws.com/wodby-sample-files/archives/export"

run() {
    docker run --rm -e DEBUG "${IMAGE}" "${@}"
}

echo "START TESTING get_archive"
echo

# Extension to test :: Allowed extensions
test_cases=(
    'zip::'
    'tar.gz::gz tgz tar.gz'
    'tgz::tgz gz'
    'sql.gz::gz tar.gz'
    'tar::tar.gz tar'
)

for index in "${test_cases[@]}" ; do
    ext="${index%%::*}"
    allowed="${index##*::}"
    dest="/tmp/${ext}/"
    url="${s3url}.${ext}"
    file="/tmp/export.${ext}"

    echo "Testing ${ext} archive with allowed extensions: ${allowed}"
    echo -n "From URL source... "
    run sh -c "get_archive ${url} ${dest} ${allowed} && [[ -e ${dest}/export.sql ]]"
    echo "OK"

    echo -n "From file source... "
    source="/tmp/export.${ext}"
    run sh -c "wget ${url} -qP /tmp && get_archive ${file} ${dest} ${allowed} && [[ -e ${dest}/export.sql ]]"
    echo "OK"
done

echo -n "Checking errors: missing params... "
run sh -c "! get_archive" | grep -iq "missing params"
echo "OK"

echo -n "Checking errors: unsupported archive... "
run sh -c "! get_archive ${s3url} /tmp/dir/ 'tmp tar.gz zip'" | grep -iq "unsupported archive"
echo "OK"

echo
echo "END TESTING get_archive"

run sh -c '[[ $(compare_semver "4.3.6" "4.3.5") == 0 ]];'
run sh -c '[[ $(compare_semver "3.3.6" "4.3.5") == 1 ]];'
run sh -c '[[ $(compare_semver "3.3.6" "4.3.5" "<") == 0 ]];'
run sh -c '[[ $(compare_semver "3.3.6" "3.3.6" "=") == 0 ]];'

run sh -c "apk add --update openssh-keygen || apk add --update openssh-client;
           gen_ssh_keys && rm /etc/ssh/ssh_rsa_key*;
           gen_ssh_keys 'rsa dsa ecdsa ed25519'"

run sh -c "apk add --update libressl || apk add --update openssl; gen_ssl_certs /tmp wodby.com test 365"

run sh -c "cd /tmp;
           curl -fSL https://nginx.org/download/nginx-1.12.2.tar.gz -o nginx.tar.gz;
           curl -fSL https://nginx.org/download/nginx-1.12.2.tar.gz.asc -o nginx.tar.gz.asc;
           apk add --update gnupg;
           export GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8;
           gpg_verify /tmp/nginx.tar.gz.asc /tmp/nginx.tar.gz"

run sh -c "cd /tmp;
           curl -o wp.gpg -fSL https://github.com/wp-cli/wp-cli/releases/download/v2.0.0/wp-cli-2.0.0.phar.gpg; \
           apk add --update gnupg;
           export GPG_KEYS=63AF7AA15067C05616FDDD88A3A2E8F226F0BC06;
           gpg_decrypt /tmp/wp.gpg /tmp/wp
           [ -f /tmp/wp ]"