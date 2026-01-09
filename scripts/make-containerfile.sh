#!/usr/bin/env bash
set -euo pipefail

# Generate Containerfile from Containerfile.template with version/metadata substitutions
# Usage: BUILD_VERSION=20250106.42 GIT_SHA=abc123 BASE_IMAGE_REF=docker.io/... ./make-containerfile.sh

BUILD_VERSION="${BUILD_VERSION:-dev}"
GIT_SHA="${GIT_SHA:-$(git rev-parse HEAD 2>/dev/null || echo "unknown")}"
BASE_IMAGE_REF="${BASE_IMAGE_REF:-$(head -n1 base-image.lock | tr -d '[:space:]')}"

sed -e "s|TEMPLATE_VERSION|${BUILD_VERSION}|" \
    -e "s|TEMPLATE_REVISION|${GIT_SHA}|" \
    -e "s|TEMPLATE_CREATED|$(date -Iseconds)|" \
    -e "s|TEMPLATE_BASE_IMAGE_REF|${BASE_IMAGE_REF}|" \
    Containerfile.template > Containerfile

echo "Generated Containerfile with:"
echo "  VERSION: ${BUILD_VERSION}"
echo "  REVISION: ${GIT_SHA}"
echo "  BASE_IMAGE_REF: ${BASE_IMAGE_REF}"
