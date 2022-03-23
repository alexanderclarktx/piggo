#!/bin/bash
set +x

# folders
ROOT=$(git rev-parse --show-toplevel)
DOCS="$ROOT/docs"
PIGGO_GAME="$ROOT/piggo-game"
PIGGO_WEB="$ROOT/piggo-web"

# cleanup
rm -rf $DOCS
rm $PIGGO_GAME/piggo.zip
rm $PIGGO_GAME/piggo.love

# build piggo-game
cd $PIGGO_GAME
zip -9 -r piggo.love .

# build piggo-web
cd $PIGGO_WEB
npm install
npx love.js -c -t piggo -m 400000000 $PIGGO_GAME/piggo.love $DOCS
cp $PIGGO_WEB/lib/js/consolewrapper.js $DOCS/
cp $PIGGO_WEB/lib/js/webdb.js $DOCS/
cd $DOCS
node ../lib/js/globalizeFS.js

# cleanup
rm $PIGGO_GAME/piggo.love

# start server
cd $ROOT
npx http-server -c-1 $DOCS

# <script src="consolewrapper.js"></script>
# <script src="webdb.js"></script>
# FS.filesystems.IDBFS.dbs["/home/web_user/love"]
