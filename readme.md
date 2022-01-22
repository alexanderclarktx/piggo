# Piggo

A 2D multiplayer online battle arena

![](./screenshots/7.png)

## building
* install [love2d](https://love2d.org/#download)
* alias `love`
  ```
  alias love="/Applications/love.app/Contents/MacOS/love"
  ```
* run the game
  ```
  love .
  ```

## TODOs

#### Mechanics

* end-to-end ARAM game logic

* auto attacks

* gold/resources

* player death and respawn

#### UI

* minimap

* damage indicators

* HUD (health, resources)

* player inventory

* ability tooltips

## refactors

* client/server

## Bugs

* movement and ability targeting is not honoring pythagoras
  * characters move faster in cardinal directions than diagonally
  * abilities are longer when facing cardinal directions
* camera position not handling window resize
* menu items not handling window resize
