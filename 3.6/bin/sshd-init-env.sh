#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

printenv | xargs -I{} echo {} | awk ' \
    BEGIN { FS = "=" }; { \
        if ($1 != "HOME" \
            && $1 != "PWD" \
            && $1 != "PATH" \
            && $1 != "SHLVL") { \
            \
            print ""$1"="$2"" \
        } \
    }' > ~/.ssh/environment
