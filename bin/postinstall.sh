GHOST_VERSION=$(node -e "console.log(require('./package.json').version)")
npm install -g pnpm
ghost install "$GHOST_VERSION" --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
echo 'GHOST INSTALL DONE'
# Copy Ghost code files (excluding node_modules)
for item in /app/build/versions/"$GHOST_VERSION"/*; do
  [ "$(basename "$item")" = "node_modules" ] && continue
  cp -Rf "$item" .
done
# Merge Ghost's node_modules into user's (--remove-destination handles symlink vs directory conflicts)
# dotglob ensures .pnpm directory is included (pnpm symlinks depend on it)
shopt -s dotglob
cp -Rf --remove-destination /app/build/versions/"$GHOST_VERSION"/node_modules/* node_modules/
shopt -u dotglob
rm -rf /app/build
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh
