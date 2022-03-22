#!/bin/bash

# dependencies
# npm -g i love.js
# npm -g i http-server

# folder for lovejs bundle
FOLDER="docs"

# cleanup
rm -rf $FOLDER

# zip up into a .love file
zip -9 -r piggo.love .

# make lovejs bundle
npx love.js -c -t piggo -m 300000000 piggo.love $FOLDER

# cleanup
rm piggo.love

# add consolewrapper dependency
cp lib/js/consolewrapper.js $FOLDER/consolewrapper.js

# start server
npx http-server $FOLDER
