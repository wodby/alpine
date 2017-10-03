# Alpine Docker Container Image

[![Build Status](https://travis-ci.org/wodby/alpine.svg?branch=master)](https://travis-ci.org/wodby/alpine)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/alpine.svg)](https://hub.docker.com/r/wodby/alpine)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/alpine.svg)](https://microbadger.com/images/wodby/alpine)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

Images are based on [alpine](https://hub.docker.com/r/_/alpine), built via [Travis CI](https://travis-ci.org/wodby/alpine) and published on [Docker Hub](https://hub.docker.com/r/wodby/alpine).

It's a basic alpine image used in docker images by Wodby

## Versions

| Image Tag                                                          | Alpine |
| ------------------------------------------------------------------ | ------ |
| [3.6](https://github.com/wodby/alpine/tree/master/3.x/Dockerfile)  | 3.6    |
| [3.4](https://github.com/wodby/alpine/tree/master/3.x/Dockerfile)  | 3.4    |

## Environment Variables

The image does not include openssh package.

| Variable                         | Default Value  | Description |
| -------------------------------- | -------------- | ----------- |
| SSHD_HOST_KEYS_DIR               | /etc/ssh       |             |
| SSHD_LOG_LEVEL                   | INFO           |             |
| SSHD_USE_PAM                     | yes            |             |
| SSHD_GATEWAY_PORTS               | no             |             |
| SSHD_PERMIT_USER_ENV             | no             |             |
| SSHD_USE_DNS                     | yes            |             |
| SSHD_USE_PRIVILEGE_SEPARATION    | sandbox        |             |
| SSHD_DISABLE_STRICT_KEY_CHECKING |                |             |
 