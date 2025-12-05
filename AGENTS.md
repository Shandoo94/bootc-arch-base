# Arch Bootc Base - Agent Guidelines

## Overview
This is a minimal bootc-compatible base image built on top of the official Arch Linux container image. It modifies the rootfs in-place and uses a two-stage build to squash layers and minimize image size.

## Build Commands
- Build container image: `podman build -t bootc-arch-base .`
- Test bootc compatibility: `podman run --rm bootc-arch-base bootc container lint`
- Inspect image: `podman run --rm -it bootc-arch-base /bin/bash`

## Architecture
- **Stage 1 (builder)**: Starts from `archlinux:latest`, relocates pacman state, installs packages, builds bootc from source, generates initramfs, and converts the filesystem layout to bootc standards
- **Stage 2 (final)**: Copies the modified rootfs from stage 1 into a `FROM scratch` image to eliminate layer history
- **Initramfs location**: `/usr/lib/modules/$kver/initramfs.img` (bootc standard)

## Key Design Decisions
- **Minimal base**: Only essential packages included; users extend for their use cases
- **Tmpfs for build deps**: Build-time dependencies (rust, git, make) installed with tmpfs mounts to keep final image small
- **In-place modification**: Modifies official Arch image rather than creating rootfs from scratch (more maintainable)

## Code Style Guidelines
- Shell scripts: Use `#!/usr/bin/env bash`, `set -euo pipefail`
- Containerfile: Use heredocs with `<<'EORUN'` for multi-line RUN commands
- Error handling: Exit with meaningful error messages to stderr
- Comments: Brief explanations for complex operations, especially pacman/dracut configs
- Security: Clean package caches after installs, minimal attack surface
- File structure: Keep mutable data under /var, immutable under /usr, follow bootc layout conventions
