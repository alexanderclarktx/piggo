local Gui = require 'src.ui.Gui'
local PlayerController = require 'src.player.PlayerController'
local DamageController = require 'src.game.DamageController'

local iGame = {}

local load, update, draw, keypressed

-- iGame is a baseclass for all games, controlling game logic, gui, player interfaces
-- the state must be initialized with a first player
function iGame.new(gameLoad, gameUpdate, gameDraw)
    assert(gameLoad, gameUpdate, gameDraw, state, state.players[1])

    local gui = Gui.new(state.players[1])
    local playerController = PlayerController.new()
    local damageController = DamageController.new()

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

    -- collisions
    state.world:update(dt)

    state.camera:update(dt)
    state.camera:follow(
        state.players[1].character.body:getX(),
        state.players[1].character.body:getY()
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

    -- print all collisions
    if debug() then
        love.graphics.setColor(1, 1, 1)
        for _, contact in pairs(state.world:getContacts()) do
            x1, y1, x2, y2 = contact:getPositions()
            local z = "%d,%d | %d, %d"
            love.graphics.print(z:format(x1 or 0, y1 or 0, x2 or 0, y2 or 0), x1, y1)
        end
    end

    -- draw and detach camera
    state.camera:detach()
    state.camera:draw()

    -- draw the GUI
    self.gui:draw()
end

function keypressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(key, scancode, isrepeat)
end

return iGame
