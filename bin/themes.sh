themes=(
  casper
	headline
	ease
	source
)

for theme in "${themes[@]}"
do
  rm -rf "content/themes/$theme"
	cp -Rf "node_modules/$theme" content/themes
done