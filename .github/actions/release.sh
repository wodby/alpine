#!/usr/bin/env bash

# Version aliases identify published releases; only primary tags publish images.
if [[ "${GITHUB_REF:-}" =~ ^refs/tags/.+-r[0-9]+$ ]]; then
    exit 0
fi

set -exo pipefail

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then      
  minor_ver="${ALPINE_VER%.*}"
  major_ver="${minor_ver%.*}"

  tags=("${minor_ver}")
  if [[ -n "${ALPINE_DEV}" ]]; then
    tags=("${minor_ver}-dev")
  fi

  if [[ -n "${LATEST_MAJOR}" ]]; then
    if [[ -n "${ALPINE_DEV}" ]]; then
      tags+=("${major_ver}-dev")
    else 
      tags+=("${major_ver}")
    fi    
  fi  
  
  if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    image_revision="${GITHUB_REF##*/}"
    tags=("${minor_ver}-${image_revision}")
    if [[ -n "${ALPINE_DEV}" ]]; then
      tags=("${minor_ver}-dev-${image_revision}")
    fi
    
    if [[ -n "${LATEST_MAJOR}" ]]; then
      if [[ -n "${ALPINE_DEV}" ]]; then
        tags+=("${major_ver}-dev-${image_revision}")
      else 
        tags+=("${major_ver}-${image_revision}")
      fi
    fi
  else
    if [[ -n "${LATEST}" ]]; then
      if [[ -n "${ALPINE_DEV}" ]]; then
        tags+=("dev")
      else
        tags+=("latest")
      fi      
    fi
  fi

  for tag in "${tags[@]}"; do
    make buildx-imagetools-create IMAGETOOLS_TAG=${tag}
  done
fi
