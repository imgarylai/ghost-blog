#!/usr/bin/env bash
set -euo pipefail

GHOST_VERSION=6.52.0

# Ghost 6.30+ ships a pnpm-managed dependency tree and ghost-cli shells out to
# pnpm during install, so pnpm must be on PATH first (otherwise: spawn pnpm ENOENT).
npm install -g pnpm

ghost install "$GHOST_VERSION" --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
echo 'GHOST INSTALL DONE'

# Resolve the actual installed version dir (robust to version-string normalization).
BUILD_VER_DIR="$(echo /app/build/versions/*/)"
BUILD_VER_DIR="${BUILD_VER_DIR%/}"

# Preserve the repo-provided packages that Ghost's pnpm node_modules does not
# contain but our scripts/runtime still need: the themes and storage adapter
# (copied into content/ by the scripts below) and 'mysql' (used by bin/wait-for-db).
mkdir -p /tmp/keep
for pkg in casper headline ease source ghost-storage-adapter-s3 mysql; do
  cp -Rf "node_modules/$pkg" /tmp/keep/ 2>/dev/null || true
done

# Ghost's node_modules is a pnpm store of symlinks/hardlinks; cp -Rf would break
# the symlinks. MOVE it wholesale so the internal links stay intact.
rm -rf node_modules
mv "$BUILD_VER_DIR/node_modules" node_modules

# Bring Ghost's generated code files (ghost.js, core/, index.js, …) into the repo
# root — everything except node_modules, which was already moved above.
for item in "$BUILD_VER_DIR"/*; do
  [ "$(basename "$item")" = "node_modules" ] && continue
  cp -Rf "$item" . 2>/dev/null || true
done
rm -rf /app/build

# Restore the preserved packages into Ghost's node_modules.
for pkg in casper headline ease source ghost-storage-adapter-s3 mysql; do
  [ -d "/tmp/keep/$pkg" ] && cp -Rf "/tmp/keep/$pkg" node_modules/ || true
done
rm -rf /tmp/keep
echo 'INSTALL TO PWD DONE'

bash -x bin/aws-s3.sh
bash -x bin/themes.sh
