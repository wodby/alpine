#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

s3url="https://s3.amazonaws.com/wodby-sample-files/archives/export"

run() {
    docker run --rm -e DEBUG "${IMAGE}" "${@}"
}

run_root() {
    docker run --user=0 --rm -e DEBUG "${IMAGE}" "${@}"
}

echo "START TESTING get-archive.sh"
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
    run sh -c "get-archive.sh ${url} ${dest} ${allowed} && [[ -e ${dest}/export.sql ]]"
    echo "OK"

    echo -n "From file source... "
    source="/tmp/export.${ext}"
    run sh -c "wget ${url} -qP /tmp && get-archive.sh ${file} ${dest} ${allowed} && [[ -e ${dest}/export.sql ]]"
    echo "OK"
done

echo -n "Checking errors: missing params... "
run sh -c "! get-archive.sh" | grep -iq "missing params"
echo "OK"

echo -n "Checking errors: unsupported archive... "
run sh -c "! get-archive.sh ${s3url} /tmp/dir/ 'tmp tar.gz zip'" | grep -iq "unsupported archive"
echo "OK"

echo
echo "END TESTING get-archive.sh"

run sh -c "compare-semver.sh 4.3.6 4.3.5"
run sh -c "compare-semver.sh 3.4.6 4.3.5 || echo 'no'" | grep -q "no"
run sh -c "compare-semver.sh 3.4.6 4.3.5 '<'"
run sh -c "compare-semver.sh 3.4.6 3.4.6 '='"

run_root sh -c "apk add --update openssh-keygen &&
                sshd-generate-keys.sh &&
                rm /etc/ssh/ssh_host_rsa_key* &&
                sshd-generate-keys.sh 'rsa dsa ecdsa ed25519'"