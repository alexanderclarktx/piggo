# Piggo

A 2D multiplayer online battle arena! Play at https://alexanderclarktx.github.io/piggo/

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

## working features

#### mechanics
```
* mostly working client/server with rollback netcode
* player, minions, abilities
* minion damage and death
```

#### ui
```
* main menu launch screen
* camera-lock, cooldown indicators
```

## TODOs

#### Mechanics

```
* auto attacks
* gold/resources
* player death and respawn
```

#### UI

```
* scoreboard (tab)
* minimap
* damage indicators
* HUD (health, resources)
* player inventory
* ability tooltips
```

## Known Bugs

```
* netcode doesn't handle minion death
* window resize not handled by camera/menu
* direction/distance calculation
  * characters move faster in cardinal directions than diagonally
  * abilities are longer when facing cardinal directions
```
