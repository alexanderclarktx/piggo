local Gui = require 'src.Gui'
local PlayerController = require 'src.PlayerController'
local DamageController = require 'src.DamageController'

local GameController = {}

local load, update, draw, keypressed

function IGameController.new(game, state)
    assert (game, state, state.players[1])

    -- local state = GameState.new(new Player())
    local gui = Gui.new(self.state.players[1], self.state)
    local playerController = PlayerController.new(state)
    local damageController = DamageController.new(selfstate)

    return {
        game = game, state = state,
        load = load, update = update, draw = draw, keypressed = keypressed,
        damageController = ,
        playerController = PlayerController.new(self.state.players[1], self.state)
        gui, playerController, damageController = nil
    }
end

function load(self)
    -- initialize DamageController
    

    -- initialize game loop
    self.game:load(self.state, self.damageController)

    -- initialize GUI, PlayerController, and DamageController
    -- self.gui = 
    -- self.playerController = 
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
