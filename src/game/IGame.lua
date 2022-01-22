local IGame = {}
local Gui = require 'src.ui.Gui'
local PlayerController = require 'src.player.PlayerController'
local DamageController = require 'src.game.DamageController'

local load, update, draw, handleKeyPressed

-- IGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function IGame.new(gameUpdate, gameDraw)
    assert(gameUpdate and gameDraw and state and state.players[1])

    local gui = Gui.new(state.players[1])
    local playerController = PlayerController.new()
    local damageController = DamageController.new()

    return {
        gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw,
        playerController = playerController, damageController = damageController,
        gui = gui,
        handleKeyPressed = handleKeyPressed
    }
end

function update(self, dt)
    assert(#state.players >= 1 and state.camera and state.world)

    -- increment state time
    state.dt = state.dt + dt

    -- update player controller
    self.playerController:update(dt)

    -- update damage controller
    self.damageController:update(dt)

    -- update all internal states
    for _, player in pairs(state.players) do player:update(dt) end

    -- update all npcs
    for index, npc in pairs(state.npcs) do npc:update(dt, index) end

    -- handle non-player non-npc objects
    for _, object in pairs(state.objects) do object:update(dt) end

    -- update game loop
    self.gameUpdate(self)

    -- collisions
    state.world:update(dt)

    -- camera to player
    state.camera:follow(
        state.players[1].character.body:getX(),
        state.players[1].character.body:getY()
    )
    state.camera:update(dt)
end

function draw(self)
    -- attach camera
    state.camera:attach()

    -- draw all terrain
    for _, terrain in pairs(state.terrains) do terrain:draw() end

    -- draw all players
    for _, player in pairs(state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(state.objects) do object:draw() end

    -- draw game-specific things
    self.gameDraw(self)

    -- draw player indicators
    self.playerController:draw()

    -- draw and detach camera
    state.camera:detach()
    state.camera:draw()

    -- draw the GUI
    self.gui:draw()
end

function handleKeyPressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(key, scancode, isrepeat)
end

return IGame
