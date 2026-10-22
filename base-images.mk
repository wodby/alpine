# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.21.9 := sha256:14e656ec688569b915129a3815ff8c524f57128c101b5527ff78514d993dea8e
BASE_IMAGE_DIGEST_3.22.7 := sha256:e9f2de928efcc1b53d0948e684b4f490315f280de6044844ec0ff26c0b44d3cf
BASE_IMAGE_DIGEST_3.23.7 := sha256:eaa20f3de212fa5cda0c64dc715b55ce28619928536d0d2a97ec1a922c1edce8
BASE_IMAGE_DIGEST_3.24.3 := sha256:b3413572228e34bd1c9245f5565e6cd127005655e8a7899aef33d8e83255c9e6

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
