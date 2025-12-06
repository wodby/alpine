#!/usr/bin/env bash

set -exo pipefail

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then      
  minor_ver="${ALPINE_VER%.*}"
  major_ver="${minor_ver%.*}"

  tags=("${minor_ver}")
  if [[ -n "${DEV}" ]]; then
    tags=("${minor_ver}-dev")
  fi

  if [[ -n "${LATEST_MAJOR}" ]]; then
    if [[ -n "${DEV}" ]]; then
      tags+=("${major_ver}-dev")
    else 
      tags+=("${major_ver}")
    fi    
  fi  
  
  if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    stability_tag="${GITHUB_REF##*/}"
    tags=("${minor_ver}-${stability_tag}")
    if [[ -n "${DEV}" ]]; then
      tags=("${minor_ver}-dev-${stability_tag}")
    fi
    
    if [[ -n "${LATEST_MAJOR}" ]]; then
      if [[ -n "${DEV}" ]]; then
        tags+=("${major_ver}-dev-${stability_tag}")
      else 
        tags+=("${major_ver}-${stability_tag}")
      fi
    fi
  else
    if [[ -n "${LATEST}" ]]; then
      if [[ -n "${DEV}" ]]; then
        tags+=("dev")
      else
        tags+=("latest")
      fi      
    fi
  fi

  for tag in "${tags[@]}"; do
    make buildx-imagetools-create TAG=${tag}
  done
fi
