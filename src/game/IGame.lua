local Gui = require 'src.ui.Gui'
local PlayerController = require 'src.player.PlayerController'
local DamageController = require 'src.game.DamageController'

local iGame = {}

local load, update, draw, keypressed

-- iGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function iGame.new(gameLoad, gameUpdate, gameDraw, state)
    assert(gameLoad, gameUpdate, gameDraw, state, state.players[1])

    local gui = Gui.new(state.players[1], state)
    local playerController = PlayerController.new(state)
    local damageController = DamageController.new(state)

    return {
        state = state,
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw, keypressed = keypressed,
        gui = gui, playerController = playerController, damageController = damageController
    }
end

function load(self)
    -- initialize game loop
    self.gameLoad(self)
end

function update(self, dt)
    -- update player controller
    self.playerController:update(dt)

    -- update damage controller
    self.damageController:update(dt)

    -- update all internal states
    for _, player in pairs(self.state.players) do player:update(dt) end

    -- update all npcs
    for index, npc in pairs(self.state.npcs) do npc:update(dt, index) end

    -- handle non-player non-npc objects
    for _, object in pairs(self.state.objects) do object:update(dt) end

    -- update game loop
    self.gameUpdate(self)
end

function draw(self)
    -- draw all players
    for _, player in pairs(self.state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(self.state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(self.state.objects) do object:draw() end

    -- draw the GUI
    self.gui:draw()

    -- draw player indicators
    self.playerController:draw()

    -- draw game-specific things
    self.gameDraw(self)
end

function keypressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(key, scancode, isrepeat)
end

return iGame
