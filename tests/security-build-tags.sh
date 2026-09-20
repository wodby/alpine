#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
# Production Makefile targets must agree across separate architecture jobs.
for variant in standard dev; do
  dev=''
  suffix=''
  if [[ "$variant" == dev ]]; then dev=1; suffix=-dev; fi
  for arch in amd64 arm64; do
    image=$(make --no-print-directory -s image-ref ALPINE_VER=3.24.2 ALPINE_DEV="$dev" ARCH="$arch" CI_BUILD_ID=123-2)
    [[ "$image" == "wodby/alpine:3.24${suffix}-build-123-2-${arch}" ]]
    push=$(make --no-print-directory -n push ALPINE_VER=3.24.2 ALPINE_DEV="$dev" ARCH="$arch" CI_BUILD_ID=123-2)
    [[ "$push" == "docker push $image" ]]
  done
  combined=$(make --no-print-directory -n buildx-imagetools-create ARCH= ALPINE_VER=3.24.2 ALPINE_DEV="$dev" CI_BUILD_ID=123-2 IMAGETOOLS_TAG="3.24${suffix}-r4")
  [[ "$combined" == *"-t wodby/alpine:3.24${suffix}-r4"* ]]
  [[ "$combined" == *"wodby/alpine:3.24${suffix}-build-123-2-amd64"* ]]
  [[ "$combined" == *"wodby/alpine:3.24${suffix}-build-123-2-arm64"* ]]
  next=$(make --no-print-directory -s image-ref ALPINE_VER=3.24.2 ALPINE_DEV="$dev" ARCH=amd64 CI_BUILD_ID=124-1)
  [[ "$next" != "wodby/alpine:3.24${suffix}-build-123-2-amd64" ]]
done
# Outside CI, retain the established local image names.
[[ "$(make --no-print-directory -s image-ref ALPINE_VER=3.24.2 CI_BUILD_ID= ALPINE_DEV= ARCH=)" == wodby/alpine:3.24 ]]
echo 'Isolated security-build image tags passed'
