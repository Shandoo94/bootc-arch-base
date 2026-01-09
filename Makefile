OCITOOL ?= podman
BASE_IMAGE_REF ?= $(shell head -n1 base-image.lock | tr -d '[:space:]')
BUILD_VERSION ?= dev
GIT_SHA ?= $(shell git rev-parse HEAD 2>/dev/null || echo "unknown")

.PHONY: help
help:
	@echo "Arch Bootc Base - Build Targets"
	@echo ""
	@echo "  make containerfile  Generate Containerfile from template"
	@echo "  make build          Generate Containerfile and build image"
	@echo "  make clean          Remove generated Containerfile"
	@echo ""
	@echo "Environment variables:"
	@echo "  OCITOOL=$(OCITOOL)"
	@echo "  BASE_IMAGE_REF=$(BASE_IMAGE_REF)"
	@echo "  BUILD_VERSION=$(BUILD_VERSION)"

.PHONY: containerfile
containerfile:
	@echo "==> Generating Containerfile from template"
	BASE_IMAGE_REF="$(BASE_IMAGE_REF)" \
	BUILD_VERSION="$(BUILD_VERSION)" \
	GIT_SHA="$(GIT_SHA)" \
	./scripts/make-containerfile.sh

.PHONY: build
build: containerfile
	@echo "==> Building bootc-arch-base:$(BUILD_VERSION)"
	$(OCITOOL) build \
		-t bootc-arch-base:$(BUILD_VERSION) \
		-t bootc-arch-base:latest \
		.

.PHONY: inspect
inspect:
	@echo "==> Inspecting bootc-arch-base:$(BUILD_VERSION)"
	$(OCITOOL) images bootc-arch-base
	@echo ""
	$(OCITOOL) inspect bootc-arch-base:$(BUILD_VERSION) | jq '.[0] | {Size: .Size, Labels: .Labels}'

.PHONY: clean
clean:
	@echo "==> Cleaning generated files"
	rm -f Containerfile
