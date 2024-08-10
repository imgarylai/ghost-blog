ghost install 5.89.1 --allow-root --no-check-empty --no-prompt --no-stack --no-setup --no-setup-linux-user --db sqlite3
cp -Rf package.json package-lock.json node_modules versions/5.89.1/
echo 'INSTALL TO versions/*/ DONE'
cp -Rf versions/5.89.1/* .
echo 'INSTALL TO PWD DONE'
bash -x bin/aws-s3.sh
bash -x bin/themes.sh