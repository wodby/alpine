# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.21.10 := sha256:bc21487101ae47172509130ee1092cc273a831968d64b617776d1f69c81e42ab
BASE_IMAGE_DIGEST_3.22.8 := sha256:49340b346798875b5592e5d420241f2f9cfba5f47e62ebb1446a1b34734e898f
BASE_IMAGE_DIGEST_3.23.8 := sha256:469c9ea410b9215eaee7976ba6c0639039b444be8e5d638f7abbada189971eb2
BASE_IMAGE_DIGEST_3.24.4 := sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
