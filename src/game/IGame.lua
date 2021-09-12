local Gui = require 'src.ui.Gui'
local PlayerController = require 'src.player.PlayerController'
local DamageController = require 'src.game.DamageController'

local iGame = {}

state = nil

local load, update, draw, keypressed

-- iGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function iGame.new(gameLoad, gameUpdate, gameDraw, initialState)
    assert(gameLoad, gameUpdate, gameDraw, initialState, initialState.players[1])

    state = initialState

    local gui = Gui.new(state.players[1])
    local playerController = PlayerController.new()
    local damageController = DamageController.new()

    state.camera:setFollowLerp(0.2)
    state.camera:setFollowLead(10)
    -- camera:setFollowStyle('LOCKON')

    return {
        gameLoad = gameLoad, gameUpdate = gameUpdate, gameDraw = gameDraw,
        load = load, update = update, draw = draw, keypressed = keypressed,
        playerController = playerController, damageController = damageController,
        gui = gui
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
    for _, player in pairs(state.players) do player:update(dt) end

    -- update all npcs
    for index, npc in pairs(state.npcs) do npc:update(dt, index) end

    -- handle non-player non-npc objects
    for _, object in pairs(state.objects) do object:update(dt) end

    -- update game loop
    self.gameUpdate(self)

    state.camera:update(dt)
    state.camera:follow(
        state.players[1].character.meta.pos.x,
        state.players[1].character.meta.pos.y
    )
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

    -- detach camera
    state.camera:detach()

    -- draw the GUI
    self.gui:draw()
end

function keypressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(key, scancode, isrepeat)
end

return iGame
