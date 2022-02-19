# Piggo

A 2D multiplayer online battle arena

![](./screenshots/8.png)

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

* auto attacks

* gold/resources

* player death and respawn

#### UI

* scoreboard (tab)

* minimap

* damage indicators

* HUD (health, resources)

* player inventory

* ability tooltips

## Known Bugs

* netcode doesn't handle minion death
* window resize not handled by camera/menu
* direction/distance calculation
  * characters move faster in cardinal directions than diagonally
  * abilities are longer when facing cardinal directions
