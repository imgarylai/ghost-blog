ghost install 5.35.0 --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
cp -Rf package.json package-lock.json node_modules versions/*/
echo 'INSTALL TO versions/*/ DONE'
cp -Rf versions/*/* .
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh