-include env_make

ALPINE_VER ?= 3.24.2
ALPINE_VER_MINOR = $(shell echo "${ALPINE_VER}" | grep -oE '^[0-9]+\.[0-9]+')

REPO = wodby/alpine
NAME = alpine-$(ALPINE_VER_MINOR)

PLATFORM ?= linux/amd64
SOURCE_COMMIT ?= $(shell git rev-parse HEAD)

ifeq ($(TAG),)
    ifneq ($(ALPINE_DEV),)
    	TAG ?= $(ALPINE_VER_MINOR)-dev
    else
        TAG ?= $(ALPINE_VER_MINOR)
    endif
endif

ifneq ($(ALPINE_DEV),)
    NAME := $(NAME)-dev
endif

IMAGETOOLS_TAG ?= $(TAG)

# Isolate architecture staging tags across daily builds and release workflows.
ifneq ($(CI_BUILD_ID),)
    override TAG := $(TAG)-build-$(CI_BUILD_ID)
endif

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push test push shell run start stop logs clean release

# Resolve the same pinned base image for every local and CI build target.
include base-images.mk
BASE_IMAGE_TAG = $(ALPINE_VER)

default: build

build:
	docker build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --build-arg SOURCE_COMMIT="$(SOURCE_COMMIT)" -t $(REPO):$(TAG) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		--build-arg ALPINE_DEV=$(ALPINE_DEV) \
		./

buildx-build:
	docker buildx build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --build-arg SOURCE_COMMIT="$(SOURCE_COMMIT)" --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		--build-arg ALPINE_DEV=$(ALPINE_DEV) \
		./

buildx-push:
	docker buildx build --build-arg BASE_IMAGE="$(BASE_IMAGE)" --build-arg SOURCE_COMMIT="$(SOURCE_COMMIT)" --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		--build-arg ALPINE_DEV=$(ALPINE_DEV) \
		./

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(IMAGETOOLS_TAG) \
				$(REPO):$(TAG)-amd64 \
				$(REPO):$(TAG)-arm64
.PHONY: buildx-imagetools-create

test:
	IMAGE=$(REPO):$(TAG) ./test.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push

# Keep CI scans aligned with the version, variant and architecture built by make.
.PHONY: image-ref
image-ref:
	@printf '%s\n' '$(REPO):$(TAG)'
