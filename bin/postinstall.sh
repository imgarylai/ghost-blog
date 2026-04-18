npm install -g pnpm
ghost install 6.30.0 --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
echo 'GHOST INSTALL DONE'
# Save custom packages before replacing node_modules
mkdir -p /tmp/custom
for pkg in casper headline ease source ghost-storage-adapter-s3; do
  cp -Rf node_modules/$pkg /tmp/custom/ 2>/dev/null || true
done
# Replace with Ghost's pnpm-managed files
rm -rf node_modules
cp -Rf /app/build/versions/6.30.0/* .
rm -rf /app/build
# Restore custom packages for theme/adapter scripts
for pkg in casper headline ease source ghost-storage-adapter-s3; do
  cp -Rf /tmp/custom/$pkg node_modules/ 2>/dev/null || true
done
rm -rf /tmp/custom
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh
