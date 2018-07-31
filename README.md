# Alpine Docker Container Image

[![Build Status](https://travis-ci.org/wodby/alpine.svg?branch=master)](https://travis-ci.org/wodby/alpine)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/alpine.svg)](https://microbadger.com/images/wodby/alpine)

This is a basic alpine image used in Wodby's docker images

## Docker Images

❗For better reliability we release images with stability tags (`wodby/alpine:3.8-X.X.X`) which correspond to [git tags](https://github.com/wodby/alpine/releases). We strongly recommend using images only with stability tags. 

About images:

* All images are based on Alpine Linux
* Base image: [alpine](https://hub.docker.com/r/_/alpine)
* [Travis CI builds](https://travis-ci.org/wodby/alpine) 
* [Docker Hub](https://hub.docker.com/r/wodby/alpine) 

[_(Dockerfile)_]: https://github.com/wodby/alpine/tree/master/Dockerfile

Supported tags and respective `Dockerfile` links:

* `3.8`, `3`, `latest` [_(Dockerfile)_]
* `3.7` [_(Dockerfile)_]
* `3.6` [_(Dockerfile)_]
* `3.5` [_(Dockerfile)_]
* `3.4` [_(Dockerfile)_]
* `3.8-dev`, `3-dev`, `dev` [_(Dockerfile)_]

## Scripts

This image contains the following helper scripts:

* `compare_semver` - compares two semantic versions
* `exec_init_scripts` - execute all `.sh` scripts from `/docker-entrypoint-init.d/`. Useful to have in every docker image
* `gen_ssh_keys` - generates SSH keys
* `gen_ssl_certs` - generate SSL certificates
* `get_archive` - copies (or downloads) and unpacks an archive
* `gpg_verify` - verify GPG signature from a list of key servers
* `wait_for` - executes a command with for N times with N timeout until it return 0

See [`test.sh`](https://github.com/wodby/alpine/blob/master/test.sh) for examples.