# Alpine Docker Container Image

[![Build Status](https://github.com/wodby/alpine/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/alpine/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)

This is a basic alpine image used in Wodby's docker images

## Docker Images

❗For better reliability we release images with stability tags (`wodby/alpine:3-X.X.X`) which correspond to [git tags](https://github.com/wodby/alpine/releases). We strongly recommend using images only with stability tags. 

About images:

* All images based on Alpine Linux
* Base image: [alpine](https://hub.docker.com/r/_/alpine)
- [GitHub actions builds](https://github.com/wodby/alpine/actions) 
* [Docker Hub](https://hub.docker.com/r/wodby/alpine) 

[_(Dockerfile)_]: https://github.com/wodby/alpine/tree/master/Dockerfile

Supported tags and respective `Dockerfile` links:

* `3.19`, `3`, `latest` [_(Dockerfile)_]
* `3.18` [_(Dockerfile)_]
* `3.17` [_(Dockerfile)_]
* `3.16` [_(Dockerfile)_]
* `3.19-dev`, `3-dev`, `dev` [_(Dockerfile)_]

All images built for `linux/amd64` and `linux/arm64`

## Scripts

This image contains the following helper scripts:

* `compare_semver` - compares two semantic versions
* `exec_init_scripts` - execute all `.sh` scripts from `/docker-entrypoint-init.d/`. Useful to have in every docker image
* `gen_ssh_keys` - generates SSH keys
* `gen_ssl_certs` - generate SSL certificates
* `get_archive` - copies (or downloads) and unpacks an archive
* `gpg_verify` - verify GPG signature from a list of key servers
* `gpg_decrypt` - decrypt an artifact that contains GPG signature
* `wait_for` - executes a command with for N times with N timeout until it return 0

See [`test.sh`](https://github.com/wodby/alpine/blob/master/test.sh) for examples.