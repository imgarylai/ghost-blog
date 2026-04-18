npm install -g pnpm
ghost install 6.30.0 --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
cp -Rf node_modules /app/build/versions/*/
echo 'INSTALL TO versions/*/ DONE'
cp -Rf /app/build/versions/*/* .
rm -rf /app/build
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh