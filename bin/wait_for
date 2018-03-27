#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [ "$#" -lt 6 ]; then
    echo "Illegal number of parameters"
fi

started=0
command=$1
service=$2
host=$3
max_try=$4
wait_seconds=$5
delay_seconds=$6

sleep "${delay_seconds}"

for i in $(seq 1 "${max_try}"); do
    if eval "${command}"; then
        started=1
        break
    fi
    echo "${service} is starting..."
    sleep "${wait_seconds}"
done

if [[ "${started}" -eq '0' ]]; then
    echo >&2 "Error. ${service} is unreachable."
    exit 1
fi

echo "${service} has started!"