# Arch Bootc Base

A minimal bootc-compatible base image built on top of the official Arch Linux container image.

## Quick Start

### Build the base image

```bash
podman build -t bootc-arch-base .
```

### Inspect the image

```bash
podman run --rm -it bootc-arch-base /bin/bash
```

## What's Included

**Minimal packages only:**
- `base` - Core Arch Linux system
- `linux` + `linux-firmware` - Kernel and firmware
- `dracut` - Initramfs generator
- `ostree` + `bootc` - Image-based OS tooling
- `skopeo` - Container image operations
- `dbus`, `glib2`, `shadow` - Essential system services

**Not included (user responsibility):**
- Network management (`networkmanager`, `systemd-networkd`)
- Desktop environments
- Additional firmware or drivers

## Architecture

- **Two-stage build**: Modifies the rootfs in stage 1, copies to `FROM scratch` in stage 2 to minimize size.
- **In-place modification**: Uses official `archlinux@sha256:...` as base. Uses digests instead of tags to ensure immutability.
- **Bootc-compliant layout**: 
  - Mutable data in `/var`
  - Immutable system in `/usr`
  - Pacman state in `/usr/lib/sysimage`
  - Initramfs at `/usr/lib/modules/$kver/initramfs.img`
