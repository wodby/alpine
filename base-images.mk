# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.21.9 := sha256:16674b554e87169a995a5658cf6ad867c3cd1b6b0007e4a142d9356250109e86
BASE_IMAGE_DIGEST_3.22.7 := sha256:83ef2b686a66ded95bcac3ff0cff91f368424cc90f3df32ea9280fb72ad3f3bd
BASE_IMAGE_DIGEST_3.23.7 := sha256:649544f99cfbb1bf2b2a5d19be5c53f76c589b423abf200f3db39d54d03a6f17
BASE_IMAGE_DIGEST_3.24.3 := sha256:1b7232cda4ca3dc20b5d1247bdc9bfb631f2661d15d323bdd6fccc035ed1a9e7

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
