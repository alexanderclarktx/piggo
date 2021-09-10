local Gui = require 'src.Gui'
local PlayerController = require 'src.PlayerController'
local DamageController = require 'src.DamageController'

local GameController = {}

local load, update, draw, keypressed

function GameController.new(game)
    return {
        game = game,
        load = load,
        update = update,
        draw = draw,
        keypressed = keypressed,
        state = { -- shared with Game
            players = {},
            npcs = {},
            hurtboxes = {},
            objects = {}
        },
        gui = nil,
        playerController = nil,
        damageController = nil
    }
end

function load(self)
    -- initialize DamageController
    self.damageController = DamageController.new(self.state)

    -- initialize game loop
    self.game:load(self.state, self.damageController)

    -- initialize GUI, PlayerController, and DamageController
    self.gui = Gui.new(self.state.players[1], self.state)
    self.playerController = PlayerController.new(self.state.players[1], self.state)
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
    self.game:update(dt)
end

function draw(self)
    -- draw all players
    for _, player in pairs(self.state.players) do player:draw() end

    -- draw all npcs
    for _, npc in pairs(self.state.npcs) do npc:draw() end

    -- draw all non-npc objects
    for _, object in pairs(self.state.objects) do object:draw() end

    -- draw the GUI and PlayerController indicators
    self.gui:draw()
    self.playerController:draw()
end

function keypressed(self, key, scancode, isrepeat)
    self.playerController:handleKeyPressed(key, scancode, isrepeat)
end

return GameController
