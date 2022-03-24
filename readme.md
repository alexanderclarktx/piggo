# Piggo

Piggo is a 2D multiplayer online battle arena!

play at https://alexanderclarktx.github.io/piggo/

![](./screenshots/8.png)

## building
* install [love2d](https://love2d.org/#download)
* alias `love`
  ```
  alias love="/Applications/love.app/Contents/MacOS/love"
  ```
* run the game
  ```
  love piggo-game
  ```
* run the standalone server
  ```
  cd piggo
  love piggo-server
  ```
* host the web server
  ```
  # dependencies
  brew install jq
  pip3 install xmltodict
  ```
  ```
  ./build.sh
  ```

## upcoming features

```
multiplayer
items/abilities/inventory
web3 wallet login
```
