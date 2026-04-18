GHOST_VERSION=$(node -e "console.log(require('./package.json').version)")
npm install -g pnpm
ghost install "$GHOST_VERSION" --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
echo 'GHOST INSTALL DONE'

# Set up themes and S3 adapter while user's npm node_modules still has them
bash -x bin/aws-s3.sh
bash -x bin/themes.sh

# Replace node_modules with Ghost's pnpm-managed one
rm -rf node_modules
mv /app/build/versions/"$GHOST_VERSION"/node_modules .

# Copy Ghost code files (content/ merges safely - existing themes/adapters preserved)
for item in /app/build/versions/"$GHOST_VERSION"/*; do
  [ "$(basename "$item")" = "node_modules" ] && continue
  cp -Rf "$item" . 2>/dev/null || true
done

rm -rf /app/build
echo 'INSTALL TO PWD DONE'
