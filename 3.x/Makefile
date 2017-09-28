-include env_make

VERSION ?= 3.6
ALPINE_VER ?= 3.6

REPO = wodby/alpine
NAME = alpine-$(ALPINE_VER)

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(VERSION) --build-arg ALPINE_VER=$(ALPINE_VER) ./

test:
	exit 0

push:
	docker push $(REPO):$(VERSION)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
