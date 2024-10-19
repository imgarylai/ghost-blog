ghost install 5.97.0 --dir /app/build --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
cp -Rf package.json package-lock.json node_modules /app/build/versions/*/
echo 'INSTALL TO versions/*/ DONE'
cp -Rf /app/build/versions/*/* .
rm -rf /app/build
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh