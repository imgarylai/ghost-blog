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

# The repo's npm node_modules holds packages Ghost's own tree does not — the S3
# storage adapter and its aws-sdk dep, mysql (bin/wait-for-db), and the theme
# packages — along with their hoisted transitive deps. Set it aside before the swap.
mv node_modules /tmp/user_nm

# Ghost's node_modules is a pnpm store of symlinks/hardlinks; cp -Rf would break
# the symlinks. MOVE it wholesale so the internal links stay intact.
mv "$BUILD_VER_DIR/node_modules" node_modules

# Bring Ghost's generated code files (ghost.js, core/, index.js, …) into the repo
# root, but keep our own package.json / package-lock.json — they carry the "start"
# script, engines and dependency set, whereas Ghost's package.json has no start
# script. node_modules was already moved above.
for item in "$BUILD_VER_DIR"/*; do
  case "$(basename "$item")" in
    node_modules|package.json|package-lock.json) continue ;;
  esac
  cp -Rf "$item" . 2>/dev/null || true
done
rm -rf /app/build

# Merge in every package the repo needs that Ghost's tree lacks, without ever
# overwriting a package Ghost already ships. Handles unscoped and scoped packages.
for dep in /tmp/user_nm/*; do
  base="$(basename "$dep")"
  case "$base" in
    @*) continue ;;
  esac
  [ -e "node_modules/$base" ] || cp -Rf "$dep" node_modules/
done
for scope in /tmp/user_nm/@*; do
  [ -d "$scope" ] || continue
  s="$(basename "$scope")"
  for pkg in "$scope"/*; do
    p="$(basename "$pkg")"
    [ -e "node_modules/$s/$p" ] || { mkdir -p "node_modules/$s"; cp -Rf "$pkg" "node_modules/$s/$p"; }
  done
done
rm -rf /tmp/user_nm
echo 'INSTALL TO PWD DONE'

bash -x bin/aws-s3.sh
bash -x bin/themes.sh
