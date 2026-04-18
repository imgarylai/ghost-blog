npm install -g pnpm
ghost install 6.30.0 --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
echo 'GHOST INSTALL DONE'
# Copy Ghost code files (excluding node_modules)
for item in /app/build/versions/6.30.0/*; do
  [ "$(basename "$item")" = "node_modules" ] && continue
  cp -Rf "$item" .
done
# Merge Ghost's node_modules into user's (--remove-destination handles symlink vs directory conflicts)
cp -Rf --remove-destination /app/build/versions/6.30.0/node_modules/* node_modules/
rm -rf /app/build
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh
